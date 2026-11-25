#!/bin/bash
# Sistem kaynaklarını izleyen araç. Seçeneğe göre işi başlatır.
#Girdi noktası: Komut satırı seçeneğine bakar , uygun işleve yönlendirir.

SURUM="0.1"
# shellcheck source=lib/log.sh
source "$(dirname "$0")/lib/log.sh"
# shellcheck source=lib/ayar.sh
source "$(dirname "$0")/lib/ayar.sh"  #ana betiğe ayar dosyası bağlandı
# shellcheck source=lib/cekirdek.sh
source "$(dirname "$0")/lib/cekirdek.sh"   #ana betiğe bağlandı
yardim_metni(){
   cat <<EOF
Pardus Süreç ve Kaynak İzleyici (sürüm $SURUM)
Çalıştırma biçimi: $0 SEÇENEK [ARGÜMAN]

 --gui               Grafik arayüz(Zenity)
 --tui               Terminal arayüz(whiptail)
 --liste             En çok kaynak kullanan süreçleri listele
 --liste --bellek    Süreçleri bellek kullanımına göre sırala
 --ayar              Geçerli ayarları göster
 --sonlandir PID     Seçilen süreci sonlandır (onay ister) 
 --yardim            Yardim metnini göster
EOF
}
ayar_yukle || exit 1   #ayarlar her çalışmada yükleniyor
case "$1" in
    --ayar)
        ayar_goster
        ;;
    --gui)
        echo "GUI kipi henüz eklenmedi."
        ;;
    --tui)
        echo "TUI kipi henüz eklenmedi."
        ;;
    --sonlandir)
        surec_sonlandir "$2" || exit 1 
        ;;
    --liste)
        siralama="${2#--}"
        siralama="${siralama:-cpu}"
        log_yaz "Süreç listesi istendi (sıralama: $siralama)"
        surecleri_listele "$siralama" || exit 1
        ;;
    --yardim|-h|"")
        yardim_metni
        ;;
    *)
        hata_yaz "Geçersiz seçenek : $1"
        yardim_metni
        exit 1
        ;;
esac
