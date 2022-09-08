define Device/iot-128m
  $(Device/iot)
  DEVICE_MODEL := IoT
  DEVICE_VARIANT := 128M
  DEVICE_DTS := nuvoton/ma35d1-iot-128m
  $(Device/select-dtb)
endef
TARGET_DEVICES += iot-128m

define Device/iot-512m
  $(Device/iot)
  DEVICE_MODEL := IoT
  DEVICE_VARIANT := 512M
  DEVICE_DTS := nuvoton/ma35d1-iot-512m
  $(Device/select-dtb)
endef
TARGET_DEVICES += iot-512m
