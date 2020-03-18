SRC_URI += "file://user_2018-10-17-14-49-00.cfg \
            file://user_2018-10-18-15-31-00.cfg \
            "
SRC_URI += "file://msp430_driver.patch \
            file://kutu_gpio_driver.patch \
            "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
