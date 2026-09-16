# Jarkom-Modul-1-2026-K-14

|No|Nama Anggota|NRP|
|---|---|---|
|1|Muhammad Satrio Utomo|5027251022
|2|Sebastian Elroi Hasian Panjaitan|5027251040|

## Pengerjaan
### Soal 1 - Satrio
> Untuk mempersiapkan pembangunan The Wired, Lain yang berperan sebagai Router membuat tiga Switch/Gateway: Switch 1 menuju dua Entitas yaitu Alice dan Mika, Switch 2 menuju Chisa, sedangkan Switch 3 menuju Knights dan Eiri. Kelima Entitas tersebut dikonfigurasi sebagai Client di GNS3.

Membuat topologi dengan 1 router, 3 switch, dan 5 entitas. dengan entitas Alice dan Mika ke switch 1, entitas Chisa ke switch 2, dan entitas Knigth dan Eiri ke switch 3.
![Topology soal nomor 1](src/soal_1-topologi.png)

Mengonfigurasikan router dengan:
```
auto eth1
iface eth1 inet static
   address 192.218.1.1
   netmask 255.255.255.0

auto eth2
iface eth2 inet static
   address 192.218.2.1
   netmask 255.255.255.0

auto eth3
iface eth3 inet static
   address 192.218.3.1
   netmask 255.255.255.0
```

Mengonfigurasikan entitas endpointnya dengan: (sebagai contoh entitas Alice)
```
auto eth0
iface eth0 inet static
   address 192.218.1.2
   netmask 255.255.255.0
   gateway 192.218.1.1
```

Pembuktian tiap entitas bisa tersambung ke router:
![Ping dari entity ke router](src/soal_1-ping-router.png)

### Soal 2 - Satrio
> Karena menurut Lain pada saat itu The Wired masih terisolasi dari dunia luar, konfigurasikan router Lain agar dapat tersambung langsung ke jaringan internet publik melalui NAT/DHCP pada interface eth0.

Menambahkan node NAT, dan disambungkan ke router:
![Topologi dengan NAT](src/soal_2-topologi.png)

Untuk mengecek apakah router berhasil nyambung ke internet dengan menggunakan `ping 8.8.8.8`:
![ping internet di router](src/soal_2-ping-internet.png)

### Soal 3 - Satrio
>Setelah router Lain terhubung ke internet, pastikan seluruh Entitas (Client) di bawah Switch 1, Switch 2, dan Switch 3 dapat saling terhubung dan berkomunikasi satu sama lain melalui konfigurasi routing.

Dengan membuat script bernama `init.sh` di dalam router:
```
sysctl -w net.ipv4.ip_forward=1
```

Tes jika entity Alice bisa ping entity lain:
![ping entitas lain, dalam contoh ini entitas Chisa](src/soal_3-ping-other-entity.png)

### Soal 4 - Satrio
>Lain ingin agar setiap Entitas (Client) memiliki kemandirian di The Wired. Konfigurasikan firewall/iptables (NAT Masquerade) dan DNS resolver agar setiap Client dapat terhubung ke internet secara mandiri (dapat melakukan ping ke 8.8.8.8 dan membuka domain web google.com).

Untuk menghubungkan ke internet bisa diselesaikan dengan mengetikkan `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s [Prefix IP].0.0/16` pada router. dengan kasus ini prefix IP = `192.218.0.0/16`:
![Entity Alice dapat melakukan ping ke internet](src/soal_4-entity-ping-internet.png)

Dan untuk menghubungkan ke domain web, mengetik `echo nameserver 8.8.8.8 > /etc/resolv.conf` ke Entity.
![Mengetik scriptnya ke router](src/soal_4-ping-google-entity.png)

Agar memudahkan mensetup ulang, kami membuat file `init.sh` di dalam router untuk semua konfigurasinya:
```
#!/bin/bash

sysctl -w net.ipv4.ip_forward=1

iptables -t nat -A POSTROUTING -o eth0 -s 192.218.0.0/16 -j MASQUERADE
```

### Soal 5 - Satrio
>Eiri tetap berupaya menanamkan kekacauan ke dalam jaringan. Untuk mengantisipasi restart tiba-tiba, pastikan seluruh konfigurasi jaringan tidak hilang saat semua node di-restart. Buat script verifikasi di /root/cek_status.sh pada router Lain yang menampilkan ringkasan interface (ip -br a) dan status tabel NAT (iptables -t nat -L -v -n) setelah reboot.

Untuk mengerjakan soal ini, tinggal membuat file di dalam router dengan nama `cek_status.sh` yang berisi:
```
#!/bin/bash

ip -br a

iptables -t nat -L -v -n
```
setelah dijalankan akan memberi output seperti berikut:
![output script cek_status.sh](src/soal_5-cek-status-output.png)

### Soal 6 - Satrio
>Mika mencurigai adanya anomali traffic pada segmen jaringannya. Jalankan generator traffic berikut (link file) pada node Mika, lalu lakukan packet sniffing menggunakan Wireshark pada interface node Mika. Terapkan display filter khusus untuk menyaring paket yang berprotokol DNS atau ICMP. Tunjukkan screenshot hasil filter beserta ringkasan paket yang lolos.

Langkah pertama adalah mendownload link file ke dalam console MIka, tapi disini saya menggunakan copy-paste manual dari source codenya.
![screenshoot hasil copas source codenya](src/soal_6-source-code.png)

Untuk melakukan packet sniffing, menginspect kabel antara node Mika dengan Switch 1, lalu start capture. maka wireshark akan terbuka, dan ketika menjalankan `traffic_protocol7.sh` maka akan muncul data di wireshark.
![melakukan capture di link cable antara switch 1 dan node Mika](src/soal_6-start-capture.png)

Hasil data capture oleh wireshark sebelum disaring:
![data capture wireshark sebelum disaring](src/soal_6-sebelum-disaring.png)

Hasil data capture setelah melakukan display filter untuk protokol paket DNS atau ICMP:
![setelah disaring](src/soal_6-setelah-disaring.png)

Setelah filter diterapkan, dari total 47 paket yang ditangkap, terdapat  paket yang lolos filter. Paket yang lolos terdiri dari ICMP Echo Request/Reply (ping) dan paket Standard query DNS yang mencoba meminta resolusi nama domain tertentu.

### Soal 7 - Satrio
> Chisa memutuskan mendirikan FTP Server pada node miliknya dengan shared folder di /var/wired/data. Terapkan kebijakan akses: user alice (hak akses read & write), user mika (dibatasi read-only), dan user eiri (dibatasi tanpa izin akses / blacklist). Buktikan konfigurasi dengan membuat file signal_alice.txt dari user alice, dan buktikan penolakan akses saat user eiri mencoba login.

Membuat setup di node Chisa sebagai FTP server dan jalankan script ini:
```
cat << 'EOF' > /root/setup_ftp.sh
#!/bin/bash
apk update
apk add vsftpd

# Setup direktori dan user
mkdir -p /var/wired/data
adduser -D alice
echo "alice:alice" | chpasswd
adduser -D mika
echo "mika:mika" | chpasswd
adduser -D eiri
echo "eiri:eiri" | chpasswd

# Setup permission folder
chown alice:root /var/wired/data
chmod 755 /var/wired/data

# Konfigurasi vsftpd
cat << 'CONF' > /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
listen=YES
listen_ipv6=NO
local_root=/var/wired/data
userlist_enable=YES
userlist_deny=YES
userlist_file=/etc/vsftpd.userlist
seccomp_sandbox=NO
CONF

# Setup blacklist
echo "eiri" > /etc/vsftpd.userlist

# Restart layanan vsftpd
killall vsftpd 2>/dev/null
vsftpd /etc/vsftpd/vsftpd.conf &
EOF
```

Lalu, untuk mengeceknya, setiap node klien (Alice, Mika, dan Eiri) untuk setiap aksesnya. Sebelumnya mengubah dan menjalankan script `init.sh` di tiap node klien yang ditambahkan dengan:
```
apk update

apk add lftp
```
Selanjutnya, di setiap node, jalankan 
```
lftp -u [username],[username] 192.218.2.2
```
untuk masuk ke server FTP milik Chisa

Output akses Alice (Bisa melakukan read & write dibuktikan dengan keberhasilan upload file `signal_alice.txt` menggunakan perintah `put`):![Alice access](src/soal_7-akses-alice.png)
Output akses Mika (Bisa melakukan read dengan melihat isi folder lewat perintah `ls`, tapi tidak bisa write karena ditolak dengan kode error `553` saat mencoba `put`):
![Mika access](src/soal_7-akses-mika.png)
Output akses Eiri (Terkena blacklist, sehingga login langsung ditolak oleh sistem dengan kode error `530 Permission denied`):
![Eiri access](src/soal_7-akses-eiri.png)

### Soal 8 - Satrio
>Kelompok rahasia Knights perlu mengirimkan dokumen laporan intelijen ke FTP Server Chisa. Lakukan koneksi FTP client dari node Knights ke FTP Server Chisa menggunakan akun alice. Upload file berikut (link file). Analisis sesi Wireshark dan sebutkan: perintah FTP untuk upload (STOR), kode status sukses server (226), dan port data TCP yang dinegosiasikan pada mode PASV.

Masuk ke console Knights, dan masukkan script lftp yang sama dengan node client lain. lalu mulai gunakan wireshark dan capture jaringan antara node Knights dengan Switch 3. dan melakukan display filter untuk hanya menampilkan paket FTP aja.

Dari node Knights, mencoba masuk ke server ftp menggunakan akun Alice.
```
lftp -u alice,alice 192.218.2.2
```
setelah berhasil login, mencoba mengirim file `knights_report.txt` sebagai dokumen rahasia dengan menggunakan `put`:
![Berhasil login ke akun Alice menggunakan node Knights dan berhasil mengirim dokumen rahasia](src/soal_8-berhasil-login-dan-put-file.png)

#### Analisis 
1. Port data TCP pada mode PASV:

Sebelum mengirim data file, klien meminta server untuk memasuki mode pasif dengan mengirimkan flag `PASV`. Server menyetujuinya dan membalas dengan `227 Entering Passive Mode (192,218,2,2,152,51)..`
![port](src/soal_8-wireshark.png) <br>
Respons ini memberikan informasi IP server dan port acak yang dibukanya untuk menerima data. Port data TCP dihitung dari dua angka terakhir (205 dan 86) dengan menggunakan perhitungan berikut:
$Port = (x \times 256) + y$ <br>
$Port = (152 \times 256) + 51$ <br>
$Port = 38963$ <br>
Dengan demikian, negosiasi berhasil dan transfer data dilakukan melalui jalur TCP port 38963.

2. Perintah Upload FTP (STOR):

Setelah jalur koneksi data terbuka, klien (Knights) menginstruksikan server untuk bersiap menyimpan file dengan mengirimkan perintah `STOR knights_report.txt`. Perintah `STOR` (Store) ini adalah terjemahan dari perintah dasar `put` yang dieksekusi oleh pengguna. <br>
![store](src/soal_8-wireshark.png)

3. Kode Status Sukses Server (226):

Server Chisa memberikan izin aliran data dengan pesan `150 Ok to send data`. Setelah isi dari dokumen `secret.txt` selesai ditransfer seluruhnya melalui port pasif, server mengonfirmasi penyelesaian tugas tersebut dengan mengirimkan kode status `226 Transfer complete..` Kode ini adalah indikator final bahwa server telah menutup koneksi data karena proses unggah file sukses 100% tanpa ada paket yang corrupt.  
![server chisa menerima data](src/soal_8-wireshark.png)

### Soal 9 - Satrio
> Mika mengakses dokumen Protokol Tujuh di (link file) dari FTP Server Chisa. Dari node Mika, unduh file tersebut menggunakan akun mika. Setelah itu, buktikan pembatasan read-only dengan mencoba mengunggah file baru dari akun mika, dan tunjukkan pesan error respon server (error 550 Permission denied) saat mika mencoba melakukan upload.

Untuk memulai, pada console Chisa (server FTP) harus diupload terlebih dahulu file `protocol7_manifesto.txt` dan memastikan file tersebut bisa dibaca oleh client lain dengan menggunakan:
```
chmod 755 /var/wired/data/protocol7_manifesto.txt
```
chmod 755 berfungsi untuk memberikan izin baca dan execute untuk grup atau user lain.

Lalu dari node Mika, mencoba mendownload file `protocol7_manifesto.txt` yang ada di FTP server, dan mencoba untuk mengunggah file `test.txt` yang nantinya akan ditolak oleh server karena Mika tidak punya izin untuk WRITE.
![Node mika ke server](src/soal_9-node-mika.png)

### Soal 10 - Satrio
> Knights melancarkan uji ketahanan koneksi ke server Chisa untuk menguji latensi jaringan The Wired. Kirimkan paket ping dari node Knights ke node Chisa dengan payload khusus 128 bytes dan interval 0.3 detik sebanyak 77 paket (ping -c 77 -s 128 -i 0.3 <IP_Chisa>). Buka Wireshark, catat nilai ICMP Type dan Code untuk Echo Request vs Echo Reply, serta analisis packet loss dan RTT (min/avg/max).

Sebelum melakukan `ping`, harus disiapkan dulu capture untuk node Knights ke Router3 dan start capture untuk membuka wireshark.

Lalu pada console Knights, mengeksekusi perintah:
```
ping -c 77 -s 128 -i 0.3 192.218.2.2
```
![Knights mencoba ping Chisa](src/soal_10-test-ping-knights.png)
![hasil ping](src/soal_10-hasil-ping.png)

#### Analisis Packet Loss dan RTT
Berdasarkan ringkasan statistik dari terminal saat perintah ping selesai dieksekusi, didapatkan hasil sebagai berikut:

Packet Loss: Dari total 77 paket yang dikirimkan (transmitted), 77 paket berhasil diterima (received) oleh server. Hal ini menghasilkan 0% packet loss, yang menunjukkan bahwa koneksi jaringan The Wired sangat stabil dan tidak ada paket yang drop di tengah jalan.

RTT (min/avg/max): Waktu tempuh bolak-balik paket (latensi) tercatat sangat baik. Nilai latensi terendah (min) adalah 0.367 ms, rata-rata latensi (avg) berada di angka 0.692 ms, dan latensi tertingginya (max) hanya menyentuh 1.008 ms.

#### Analisis Wireshark
Hasil melakukan Wireshark:
![hasil melakukan wireshark](src/soal_10-hasil-wireshark.png)

Melalui pengamatan detail paket pada Wireshark dengan filter icmp, tercatat interaksi request-reply yang merepresentasikan perintah ping tersebut.<br>
Berdasarkan header Internet Control Message Protocol, terdapat dua jenis pesan utama: <br>
![Nilai ping request dari Knights ke Chisa](src/soal_10-ping-request.png) <br>
Echo Request (Knights $\rightarrow$ Chisa): Paket yang berisi permintaan dari klien ini membawa nilai Type: 8 dan Code: 0. <br>
![Nilai ping reply dari Chisa ke Knights](src/soal_10-ping-reply.png)
Echo Reply (Chisa $\rightarrow$ Knights): Paket balasan dari server merespons dengan nilai Type: 0 dan Code: 0.<br>

### Soal 11 - Satrio
> Buktikan kelemahan protokol Telnet dengan membuat akun phantom_user dan password wired_ghost pada layanan telnetd di node Chisa. Lakukan login Telnet dari node Eiri ke node Chisa dan tangkap sesi menggunakan Wireshark. Tunjukkan kredensial plain text melalui fitur Follow TCP Stream, serta jelaskan mengapa setiap karakter terkirim dalam paket TCP terpisah.

Menyiapkan dahulu akun `phantom_user` dengan script yang saya tulis di file `setup_telnet.sh` dan dieksekusi:
```
#!/bin/bash
apk update
apk add busybox-extras

=adduser -D phantom_user 2>/dev/null

echo "phantom_user:wired_ghost" | chpasswd

killall telnetd 2>/dev/null
telnetd

echo "Telnet Server sudah menyala dan siap menerima koneksi!"
```
![sript dieksekusi di node Chisa](src/soal_11-script-ecexuted.png)

Setelah itu, mulai capturing dari Node Eiri ke switch3.

Dari node Eiri, melakukan perintah:
```
telnet 192.218.2.2
```
Untuk menyambungkan ke server, dan masukkan login dengan user `phantom_user` dengan password `wired_ghost`:
![Berhasil login ke akun Chisa menggunakan console Eiri](src/soal_11-eiri-berhasil-login-chisa.png)

Setelah itu melakukan analisis di wireshark dengan memilih salah satu package telnet yang terekam lalu `right click`, pilih `follow` $\rightarrow$ `TCP Stream`. Disana terdapat informasi login dan password yang tidak terenkripsi sama sekali (berupa plain text):
![user dan password terlihat](src/soal_11-password-and-user-shown.png)

### Soal 12 - Satrio
>Alice mencurigai Knights menjalankan beberapa layanan rahasia di node-nya. Lakukan pemindaian port dari node Alice ke node Knights menggunakan Netcat (nc) untuk memeriksa port 22 (SSH) dan 80 (HTTP) dalam keadaan terbuka, serta port rahasia 7777 dalam keadaan tertutup. Analisis di Wireshark perbedaan TCP Flag yang dikembalikan antara port terbuka (SYN-ACK) dengan port tertutup (RST-ACK).

Setup capture dari node Alice, lalu menambahkan filter pada wireshark `tcp.port == 22 || tcp.port == 80 || tcp.port == 7777`.