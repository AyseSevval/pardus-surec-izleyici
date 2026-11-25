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
# PID'i doğrular: sayı mı, süreç var mı, korunan bir süreç mi?
pid_dogrula() {
    local pid="$1"

    if [[ ! "$pid" =~ ^[0-9]+$ ]]; then   #baştan sona sadece rakam mı diye kontrol eder.
        hata_yaz "Geçersiz PID: '$pid' (sadece rakam girilmeli)"
        return 1
    fi

    if [[ "$pid" -eq 1 || "$pid" -eq $$ ]]; then #betiğin kendi PID'i kendini yanlışlıkla  öldürmeyi önler 
        hata_yaz "PID $pid korumalı, işlem yapılmadı"
        return 1
    fi

    if [[ ! -d "/proc/$pid" ]]; then   #sadece çalışan süreçler için vardır.
        hata_yaz "PID $pid ile çalışan bir süreç yok"
        return 1
    fi
}

surec_sonlandir() {
    local pid="$1"
    local ad cevap

    pid_dogrula "$pid" || return 1

    ad="$(ps -p "$pid" -o comm=)"
    read -r -p "$pid ($ad) sonlandırılsın mı? (e/H): " cevap

    case "$cevap" in
        e|E)
            if kill -TERM "$pid" 2>> "$HATA_DOSYASI"; then   #kill -TERM  sürece kapan der zorla öldürmez.
                log_yaz "PID $pid ($ad) sonlandırıldı"
                echo "Süreç sonlandırıldı."
            else
                hata_yaz "PID $pid sonlandırılamadı (yetki yetersiz olabilir)"
                return 1
            fi
            ;;
        *)
            log_yaz "PID $pid sonlandırma iptal edildi"
            echo "İptal edildi."
            ;;
    esac
}
# Sürece sinyal gönderir. Durdurma ve devam ettirme bu ortak fonksiyonu kullanır.
surece_sinyal_gonder() {
    local pid="$1" sinyal="$2" eylem="$3"
    local ad

    pid_dogrula "$pid" || return 1
    ad="$(ps -p "$pid" -o comm=)"

    if kill -"$sinyal" "$pid" 2>> "$HATA_DOSYASI"; then
        log_yaz "PID $pid ($ad) $eylem"
        echo "PID $pid ($ad) $eylem."
    else
        hata_yaz "PID $pid için işlem yapılamadı (yetki yetersiz olabilir)"
        return 1
    fi
}

surec_durdur()       { surece_sinyal_gonder "$1" STOP "durduruldu"; }
surec_devam_ettir()  { surece_sinyal_gonder "$1" CONT "devam ettirildi"; }

surec_oncelik_degistir() {
    local pid="$1" deger="$2"
    local ad

    pid_dogrula "$pid" || return 1

    if [[ ! "$deger" =~ ^-?[0-9]+$ ]] || (( deger < -20 || deger > 19 )); then
        hata_yaz "Geçersiz öncelik: '$deger' (-20 ile 19 arasında tam sayı olmalı)"
        return 1
    fi

    ad="$(ps -p "$pid" -o comm=)"
    #Önceliği ayarlar.Sayı büyüdükçe süreç daha düşük öncelik alır.
    if renice -n "$deger" -p "$pid" > /dev/null 2>> "$HATA_DOSYASI"; then   
        log_yaz "PID $pid ($ad) önceliği $deger yapıldı"
        echo "PID $pid ($ad) önceliği $deger yapıldı."
    else
        hata_yaz "PID $pid önceliği değiştirilemedi (yetki yetersiz olabilir)"
        return 1
    fi
}
