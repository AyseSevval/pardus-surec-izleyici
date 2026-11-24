#!/bin/bash
# Süreç işlemleri: listeleme, durdurma, sonlandırma vb.
# Sistemde çalışan süreçleri azalan sıraya göre listeler. 
# LISTE_SAYISI değişkenine göre sınırlar ve awk ile hizalı bir tablo halinde ekrana yazar.
# Tüm süreçleri seçilen sütunlarla CPU'ya göre büyükten küçüğe sıralar.
# Local değişkenler sadece fonksiyonun içinde yaşar 
# ${1:-cpu}: fonksiyona argüman verilmezse cpu kullanılır.
surecleri_listele() {
    local siralama="${1:-cpu}"
    local alan

    case "$siralama" in
        cpu)    alan="-%cpu" ;;
        bellek) alan="-%mem" ;;
        *)
            hata_yaz "Geçersiz sıralama: $siralama (cpu veya bellek olmalı)"
            return 1
            ;;
    esac
    ps -eo pid,user:12,%cpu,%mem,comm --sort="$alan" \
        | head -n "$((LISTE_SAYISI + 1))" \
        | awk 'NR==1 {printf "%-8s %-12s %6s %7s  %s\n", "PID", "KULLANICI", "CPU%", "BELLEK%", "KOMUT"; next}
               {printf "%-8s %-12s %6s %7s  %s\n", $1, $2, $3, $4, $5}'
}
