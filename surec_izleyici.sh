#!/bin/bash
# Sistem kaynaklarını izleyen araç. Seçeneğe göre işi başlatır.
#Girdi noktası: Komut satırı seçeneğine bakar , uygun işleve yönlendirir.

SURUM="0.1"
yardim_metni(){
   cat <<EOF
Pardus Süreç ve Kaynak İzleyici (sürüm $SURUM)
Çalıştırma biçimi: $0 SEÇENEK [ARGÜMAN]

 --gui          Grafik arayüz(Zenity)
 --tui          Terminal arayüz(whiptail)
 --liste        En çok kaynak kullanan süreçleri listele 
 --yardim       Yardim metnini göster
EOF
}

case "$1" in 
    --gui)
        echo "GUI kipi henüz eklenmedi."
        ;;
    --tui)
        echo "TUI kipi henüz eklenmedi."
        ;;
    --liste)
        echo "Süreç listesi henüz eklenmedi."
        ;;
    --yardim|-h|"")
        yardim_metni
        ;;
    *)
        echo "Hata: geçersiz seçenek :$1" >&2
        yardim_metni
        exit 1
        ;;
esac
