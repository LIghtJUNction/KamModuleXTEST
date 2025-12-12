#!/system/bin/sh

# Example Module Name customize.sh
#
# This script is sourced by the module installer script after all files are extracted
# and default permissions/secontext are applied.
#
# Useful for:
# - Checking device compatibility (ARCH, API)
# - Setting special permissions
# - Customizing installation based on user environment
#
# ---------------------------------------------------------------------------------------
# AVAILABLE VARIABLES
# ---------------------------------------------------------------------------------------
# (KernelSU-only) KSU (bool):           true if running in KernelSU environment
# (KernelSU-only) KSU_VER (string):     KernelSU version string (e.g. v0.9.5)
# (KernelSU-only) KSU_VER_CODE (int):   KernelSU version code (userspace)
# (KernelSU-only) KSU_KERNEL_VER_CODE (int): KernelSU version code (kernel space)
# NOTE: KernelSU variables are only provided by KernelSU (not guaranteed on stock Magisk).
# Guard usage example:
#    if [ "$KSU" = "true" ]; then
#        # KernelSU-only logic
#    else
#        # Fallback for Magisk/APatch or other environments
#    fi
#
# KernelPatch/KernelSU/APatch related variables
# (KernelPatch-only) KERNELPATCH (bool):   true if running in KernelPatch environment
# (KernelPatch-only) KERNEL_VERSION (hex): Kernel version inherited from KernelPatch (e.g. 50a01 -> 5.10.1)
# (KernelPatch-only) KERNELPATCH_VERSION (hex): KernelPatch version identifier (e.g. a05 -> 0.10.5)
# (KernelPatch-only) SUPERKEY (string):    Value provided by KernelPatch for invoking kpatch/supercall
# NOTE: The KernelPatch variables above are provided by KernelPatch and may NOT exist on a stock Magisk installation.
#       If your module must work on both, check for their presence before using them:
#         if [ -n "$KERNELPATCH" ] && [ "$KERNELPATCH" = "true" ]; then
#           # KernelPatch-specific handling
#         fi
#
# APatch related variables
# (APatch-only) APATCH (bool):        true if running in APatch environment
# (APatch-only) APATCH_VER_CODE (int): APatch current version code (e.g. 10672)
# (APatch-only) APATCH_VER (string):  APatch version string (e.g. "10672")
# NOTE: The APatch variables above are specific to APatch (a Magisk fork). They are NOT guaranteed to exist on stock Magisk.
#       Guard your scripts like:
#         if [ "$APATCH" = "true" ]; then
#           # APatch-specific logic
#         fi
#
# Common environment variables (present across environments)
# BOOTMODE (bool):      always true in KernelSU and APatch (recovery / boot mode)
# MODPATH (path):       Path where module files are installed (e.g. /data/adb/modules/KamModuleXTEST)
# TMPDIR (path):        Path to temporary directory
# ZIPFILE (path):       Path to the installation ZIP
# ARCH (string):        Device architecture: arm, arm64, x86, x64
# IS64BIT (bool):       true if ARCH is arm64 or x64
# API (int):            Android API level (e.g. 33 for Android 13)
#
# WARNING:
# - In APatch, MAGISK_VER_CODE is typically 27000 and MAGISK_VER is 27.0 (so some Magisk-related checks behave differently).
# - Many KernelPatch/APatch features are not present on stock Magisk. When writing portable installation code,
#   explicitly check for variable presence and provide sensible fallbacks:
#     if [ -n "$APATCH" ] && [ "$APATCH" = "true" ]; then
#         # APatch-only handling
#     else
#         # Stock Magisk fallback handling (or skip)
#     fi
#
# ---------------------------------------------------------------------------------------
# AVAILABLE FUNCTIONS
# ---------------------------------------------------------------------------------------
# ui_print <msg>
#     Print message to console. Avoid 'echo'.
#
# abort <msg>
#     Print error message and terminate installation.
#
# set_perm <target> <owner> <group> <permission> [context]
#     Set permissions for a file.
#     Default context: "u:object_r:system_file:s0"
#
# set_perm_recursive <dir> <owner> <group> <dirperm> <fileperm> [context]
#     Recursively set permissions for a directory.
#     Default context: "u:object_r:system_file:s0"
#
# ---------------------------------------------------------------------------------------
# KERNELSU FEATURES
# ---------------------------------------------------------------------------------------
#
# REMOVE (Whiteout):
# List directories/files to be "removed" from the system (overlaid with whiteout).
# KernelSU executes: mknod <TARGET> c 0 0
#
# REMOVE="
# /system/app/BloatwareApp
# /system/priv-app/AnotherApp
# "
#
# REPLACE (Opaque):
# List directories to be replaced by an empty directory (or your module's version).
# KernelSU executes: setfattr -n trusted.overlay.opaque -v y <TARGET>
#
# REPLACE="
# /system/app/YouTube
# "
#
# ---------------------------------------------------------------------------------------
# CUSTOM INSTALLATION LOGIC
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------
# Use Nga utils 👇
# -----------------------------------------------------------------------------------
# [ -f "$MODPATH/lib/nga-utils.sh" ] && . "$MODPATH/lib/nga-utils.sh" || abort '! File "nga-utils.sh" does not exist!'
# nga_install_init # Don't write code before this line!

# 🚨中文提示：如果需要启用nga-utils请取消以上注释

# ---------------------------------------------------------------------------------
# Use Nga utils 👆
# -----------------------------------------------------------------------------------


ui_print "- Installing Example Module Name..."
# Check environment
if [ "$KSU" = "true" ]; then
  ui_print "- Running in KernelSU environment"
  ui_print "- KernelSU Version: $KSU_VER ($KSU_VER_CODE)"
else
  ui_print "- Running in Magisk/Other environment"
fi

# Example: Check Android Version
# if [ "$API" -lt 26 ]; then
#   abort "! Android 8.0+ required"
# fi

# Example: Check Architecture
# if [ "$ARCH" != "arm64" ]; then
#   abort "! Only arm64 is supported"
# fi

# If you have scripts, make them executable
# set_perm "$MODPATH/service.sh" 0 0 0755
# set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
# set_perm "$MODPATH/action.sh" 0 0 0755

# 🚨中文提示：请记得安装脚本里面使用MODPATH环境变量

# ---------------------------------------------------------------------------------------
# FULL CONTROL (SKIPUNZIP)
# ---------------------------------------------------------------------------------------
# 🚨 不建议，开启后可以实现更加复杂的逻辑。
# 比如：使用lib/verify.sh验证模块安装包
#
# If you want to handle extraction manually, uncomment the line below.
# SKIPUNZIP=1
#
# If SKIPUNZIP=1 is set, you must extract files yourself:
# unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2




# ---------------------------------------------------------------------------------
# 🔨code here

# run2null echo "这句话将消失"
# run22null echo "这句话不会消失" # 仅移除标准错误
# echo $(until_key) # 输出按下的按键

# 音量+	KEY_VOLUMEUP	up
# 音量-	KEY_VOLUMEDOWN	down
# 电源键	KEY_POWER	power
# 静音键	KEY_MUTE	mute
# 肩键等额外按键	KEY_FX	fX

# echo $(until_key_up_down) # 输出按下的按键，只能为 up 或 down
# echo $(until_key_up_down_power) # 输出按下的按键，只能为 up 或 down 或 power

# echo $(until_key_up) # 输出按下的按键，只能为 up
# echo $(until_key_down) # 输出按下的按键，只能为 down
# echo $(until_key_power) # 输出按下的按键，只能为 power

# goto_url "https://bilibili.com" # 跳转 bilibili
# goto_app "ren.shiror.su/dev.oom_wg.ssu.SSUUI" # 打开app

# echo "我现在在 '$(get_work_dir .)' 正好好待着呢" # 输出后将会是 “我现在在 '<当前目录的父目录路径>' 正好好待着呢”

# newline # 不传入内容，默认打印一行空行

# newline 3 # 传入内容，打印指定行数的空行


# ---------------------------------------------------------------------------------
# 🚨 中文提示：如果用nga-utils记得取消注释以下内容
# nga_install_done # Don't write code after this line!
