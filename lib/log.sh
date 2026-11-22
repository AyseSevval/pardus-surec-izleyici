#!/bin/bash
#Log Fonksiyonları : İşlemleri ve hataları tarihle birlikte dosyaya yazar.

LOG_DIZINI="$(dirname "${BASH_SOURCE[0]}")/../logs" #BASH_SOURCE[0] betiği nerden çalıştırırsam çalıştırayım logs klasörü doğru bulunur.
LOG_DOSYASI="$LOG_DIZINI/surec_izleyici.log"
HATA_DOSYASI="$LOG_DIZINI/hata.log"

log_yaz() {
    echo "$(date '+%F %T') [BILGI] $*" >> "$LOG_DOSYASI"  #tarihi  2026-11-22 13:10:05 biçiminde verir.
}
hata_yaz(){
    echo "$(date '+%F %T') [HATA] $*" >> "$HATA_DOSYASI"
    echo "Hata: $*" >&2
}

