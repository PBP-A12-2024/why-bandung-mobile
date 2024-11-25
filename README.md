# why-bandung-mobile

<p>
  Daftar Anggota
  <ul>
    <li>Farrel Dharmawan Dwiyudanto - 2306275506</li>
    <li> Najya Johara Robby - 2306245674</li>
    <li>Hubban Syadid - 2306165830</li>
    <li>Muhammad Fadhil Nur Aziz - 2306275531</li>
    <li>Karina Maharani - 2306165736</li>
  </ul>
</p>

<details>
  <summary>i. Deskripsi Aplikasi</summary>
Pernahkah Anda kesulitan untuk menemukan restoran yang anda inginkan selama berjalan-jalan di kota bandung, atau kesulitan mencari tempat kuliner yang menyediakan makanan minuman khas bandung?
  <br><br>
WhyBandung hadir untuk membantu baik wisatawan maupun warga lokal dalam menemukan kuliner terbaik di Bandung. Situs ini dilengkapi dengan sistem navigasi berbasis peta yang unik dan intuitif, sehingga memudahkan pengguna mencari makanan dan minuman yang diinginkan. WhyBandung memungkinkan pengguna untuk mengeksplorasi kuliner di berbagai wilayah berdasarkan lokasi atau kategori makanan. Selain itu, WhyBandung akan terus mengembangkan dan memperbarui daftar lokasi kuliner secara berkala.  
WhyBandung kini tersedia dalam bentuk aplikasi mobile anda dan terintegrasi dengan situs web kami, sehingga WhyBandung bisa diakses dimana saja.
  <br><br>
Tim A12SITEK memilih Kota Bandung karena dikenal sebagai kota wisata yang populer dengan ragam kuliner yang khas. Namun, terdapat kekurangan dalam sistem navigasi kuliner di Bandung. Wisatawan sering kali tidak mengetahui kuliner khas di suatu daerah karena sistem pencarian aplikasi seperti Google Maps mengharuskan pengguna untuk mencari makanan secara spesifik. Akibatnya, wisatawan cenderung mengunjungi tempat-tempat kuliner yang sudah terkenal, sehingga melewatkan kedai-kedai lokal yang lebih autentik. Padahal, kuliner lokal memberikan pengalaman yang lebih khas dan mendalam terhadap budaya suatu daerah. Inilah yang mendorong kami untuk mengembangkan WhyBandung.
</details>

<details>
  <summary>ii. Daftar modul yang akan diimplementasikan  beserta pembagian kerja per anggota</summary>
1. Dashboard - Karina Maharani<br><br>  
  
Section Home<br>
Features:
- Navigation hub, link ke modul-modul lain.  
- Landing Page yang membaca data, memiliki Link-link ke product highly-rated, dan banner ke modul lainnya 
- Search bar yang tersambung dengan modul search system.   


Rincian regulasi aturan khusus:
- Responsive Framework: Tailwind atau Bootstrap memastikan tampilan tetap ramah mobile.  
- Forms: Memiliki form aksi cepat (misalnya, searchbar).  
- Product Filtering: Menyaring restoran atau hidangan berdasarkan preferensi.  
  Section Profil
  
Section Profile<br>
Features:  
- Journal Entry. User mengupload cerita terkait pengalaman mereka dengan beberapa tempat  
- Link-link ke lokasi yang ada di journal entry and associated review/entry made by user at halaman produk toko.  

Rincian regulasi aturan khusus:
- Responsive Framework: Memastikan halaman dioptimalkan untuk semua perangkat.
- Forms: Review dan rating forms, diproses oleh views.
- Login Filters: Hanya logged-in users yang bisa memberikan review dan rate.
- Product Filtering: Related products dan user reviews bisa difilter berdasarkan tags atau ratings.
  
CRUD
- CREATE: Membuat Journal Entry (reviews, tambahkan rating, dan tag) di Dashboard section profil
- READ : Mengambil data produk, sejarah Jurnal Pengguna.
- UPDATE: Mengubah isi Jurnal Entry.
- DELETE: Menghapus sebuah Jurnal Entry.
  
...CONTINUE HERE...  

</details>

<details>
  <summary>iii. Deskripsi role-role User dan Wewenang</summary>
1. Dashboard<br><br>  
  
User Biasa:
- Bisa melihat recent activity seperti pencarian terbaru atau ulasan yang pernah dibuat.
- Bisa CRUD Jurnal Entry pada toko pada profil User
- Melihat favorite products atau restoran yang sudah pernah di-review atau diberi rating.
- Akses ke link highly-rated products berdasarkan preferensi mereka.
- Gunakan search bar untuk menelusuri produk atau restoran.

<br>

Developer:  
- Sama seperti User Biasa, tapi ditambah kemampuan untuk melakukan CRUD pada data terkait produk atau restoran.
- Bisa menambah link ke fitur lain yang hanya diakses oleh developer.

...CONTINUE HERE...
  
</details>

<details>
  <summary>iv. Alur pengintegrasian dengan web service untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester</summary>
  Untuk melakukan pengintegrasian dengan web service kami akan menggunakan JSON sebagai alat komunikasi terhadap model yang ada pada database kami selain itu kami juga
  akan memanfaatkan http request untuk mengambil dan mengirim data secara dinamis antara web dan juga aplikasi.

  Kita akan menggunakan beberapa library tambahan untuk fitur FoodFinder dan GeoMapping.

  Tahapan :
  1. Mempersiapkan JSON Model dan JSONResponse :
     - Definisikan serializer untuk mengonversi data database Django menjadi JSON.
     - Menyediakan endpoint RESTful dengan menggunakan Django REST Framework (DRF) untuk mempermudah pengelolaan JSONResponse sesuai keperluan.
  2. Membuat fungsi khusus mobile pada proyek Django untuk semua CRUD, FoodFinder, dan GeoMapping yang platform specific
     - Melakukan riset terkait API atau UI Graphics yang bisa digunakan untuk implementasi fitur FoodFinder dan GeoMapping
     - Melakukan implementasi untuk Asynchronous Data Handling untuk fitur GeoMapping
  3. Mendata dan mengimplementasi semua area yang memerlukan http request dari situs web
     - Menggunakan library http  di Flutter untuk mengirim dan mengambil data dari server Django.
  4. Melakukan testing antara kedua program dengan test case, placeholder, dan lain-lain.
     - Menggunakan Unit Test pada proyek django yang berkaitan dengan integrasi flutter
     - Mengguakan widget test atau integration test pada proyek flutter

  
</details>
