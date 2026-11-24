#!/bin/bash
# Sistem kaynaklarını izleyen araç. Seçeneğe göre işi başlatır.
#Girdi noktası: Komut satırı seçeneğine bakar , uygun işleve yönlendirir.

SURUM="0.1"
source "$(dirname "$0")/lib/log.sh"
source "$(dirname "$0")/lib/ayar.sh"  #ana betiğe ayar dosyası bağlandı
yardim_metni(){
   cat <<EOF
Pardus Süreç ve Kaynak İzleyici (sürüm $SURUM)
Çalıştırma biçimi: $0 SEÇENEK [ARGÜMAN]

 --gui          Grafik arayüz(Zenity)
 --tui          Terminal arayüz(whiptail)
 --liste        En çok kaynak kullanan süreçleri listele
 --ayar         Geçerli ayarları göster 
 --yardim       Yardim metnini göster
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
    --liste)
        log_yaz "Süreç listesi istendi"
        echo "Süreç listesi henüz eklenmedi."
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
