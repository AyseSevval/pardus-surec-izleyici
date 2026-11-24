#!/bin/bash
# Ayar dosyasını okur, eksikse açıklamalı şekilde hata verir.

AYAR_DOSYASI="${AYAR_DOSYASI:-$(dirname "${BASH_SOURCE[0]}")/../ayar.conf}"

ayar_yukle() {
    if [[ ! -r "$AYAR_DOSYASI" ]]; then   #dosya yoksa hata veriyor
        hata_yaz "Ayar dosyası okunamadı: $AYAR_DOSYASI"
        return 1
    fi
    # shellcheck source=/dev/null
    source "$AYAR_DOSYASI"
    log_yaz "Ayarlar yüklendi: $AYAR_DOSYASI"
}

ayar_goster() {
    echo "CPU eşiği     : %$CPU_ESIGI"
    echo "Bellek eşiği  : %$BELLEK_ESIGI"
    echo "Disk eşiği    : %$DISK_ESIGI"
    echo "Liste sayısı  : $LISTE_SAYISI"
}
