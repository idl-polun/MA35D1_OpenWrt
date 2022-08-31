define Device/som-256m
  $(Device/som)
  DEVICE_MODEL := SOM
  DEVICE_VARIANT := 256M
  DEVICE_DTS := nuvoton/ma35d1-som-256m
  $(Device/select-dtb)
endef
TARGET_DEVICES += som-256m

define Device/som-512m
  $(Device/som)
  DEVICE_MODEL := SOM
  DEVICE_VARIANT := 512M
  DEVICE_DTS := nuvoton/ma35d1-som-512m
  $(Device/select-dtb)
endef
TARGET_DEVICES += som-512m

define Device/som-1g
  $(Device/som)
  DEVICE_MODEL := SOM
  DEVICE_VARIANT := 1G
  DEVICE_DTS := nuvoton/ma35d1-som-1g
  $(Device/select-dtb)
endef
TARGET_DEVICES += som-1g
