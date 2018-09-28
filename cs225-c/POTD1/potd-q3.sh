#!/bin/sh
# This script was generated using Makeself 2.3.0

ORIG_UMASK=`umask`
if test "n" = n; then
    umask 077
fi

CRCsum="2546422011"
MD5="81fdd0fa573fee0e582175f85b2fbd7c"
TMPROOT=${TMPDIR:=/tmp}
USER_PWD="$PWD"; export USER_PWD

label="Extracting potd-q3"
script="echo"
scriptargs="The initial files can be found in the newly created directory: potd-q3"
licensetxt=""
helpheader=''
targetdir="potd-q3"
filesizes="77949"
keep="y"
nooverwrite="n"
quiet="n"
nodiskspace="n"

print_cmd_arg=""
if type printf > /dev/null; then
    print_cmd="printf"
elif test -x /usr/ucb/echo; then
    print_cmd="/usr/ucb/echo"
else
    print_cmd="echo"
fi

unset CDPATH

MS_Printf()
{
    $print_cmd $print_cmd_arg "$1"
}

MS_PrintLicense()
{
  if test x"$licensetxt" != x; then
    echo "$licensetxt"
    while true
    do
      MS_Printf "Please type y to accept, n otherwise: "
      read yn
      if test x"$yn" = xn; then
        keep=n
	eval $finish; exit 1
        break;
      elif test x"$yn" = xy; then
        break;
      fi
    done
  fi
}

MS_diskspace()
{
	(
	if test -d /usr/xpg4/bin; then
		PATH=/usr/xpg4/bin:$PATH
	fi
	df -kP "$1" | tail -1 | awk '{ if ($4 ~ /%/) {print $3} else {print $4} }'
	)
}

MS_dd()
{
    blocks=`expr $3 / 1024`
    bytes=`expr $3 % 1024`
    dd if="$1" ibs=$2 skip=1 obs=1024 conv=sync 2> /dev/null | \
    { test $blocks -gt 0 && dd ibs=1024 obs=1024 count=$blocks ; \
      test $bytes  -gt 0 && dd ibs=1 obs=1024 count=$bytes ; } 2> /dev/null
}

MS_dd_Progress()
{
    if test x"$noprogress" = xy; then
        MS_dd $@
        return $?
    fi
    file="$1"
    offset=$2
    length=$3
    pos=0
    bsize=4194304
    while test $bsize -gt $length; do
        bsize=`expr $bsize / 4`
    done
    blocks=`expr $length / $bsize`
    bytes=`expr $length % $bsize`
    (
        dd ibs=$offset skip=1 2>/dev/null
        pos=`expr $pos \+ $bsize`
        MS_Printf "     0%% " 1>&2
        if test $blocks -gt 0; then
            while test $pos -le $length; do
                dd bs=$bsize count=1 2>/dev/null
                pcent=`expr $length / 100`
                pcent=`expr $pos / $pcent`
                if test $pcent -lt 100; then
                    MS_Printf "\b\b\b\b\b\b\b" 1>&2
                    if test $pcent -lt 10; then
                        MS_Printf "    $pcent%% " 1>&2
                    else
                        MS_Printf "   $pcent%% " 1>&2
                    fi
                fi
                pos=`expr $pos \+ $bsize`
            done
        fi
        if test $bytes -gt 0; then
            dd bs=$bytes count=1 2>/dev/null
        fi
        MS_Printf "\b\b\b\b\b\b\b" 1>&2
        MS_Printf " 100%%  " 1>&2
    ) < "$file"
}

MS_Help()
{
    cat << EOH >&2
${helpheader}Makeself version 2.3.0
 1) Getting help or info about $0 :
  $0 --help   Print this message
  $0 --info   Print embedded info : title, default target directory, embedded script ...
  $0 --lsm    Print embedded lsm entry (or no LSM)
  $0 --list   Print the list of files in the archive
  $0 --check  Checks integrity of the archive

 2) Running $0 :
  $0 [options] [--] [additional arguments to embedded script]
  with following options (in that order)
  --confirm             Ask before running embedded script
  --quiet		Do not print anything except error messages
  --noexec              Do not run embedded script
  --keep                Do not erase target directory after running
			the embedded script
  --noprogress          Do not show the progress during the decompression
  --nox11               Do not spawn an xterm
  --nochown             Do not give the extracted files to the current user
  --nodiskspace         Do not check for available disk space
  --target dir          Extract directly to a target directory
                        directory path can be either absolute or relative
  --tar arg1 [arg2 ...] Access the contents of the archive through the tar command
  --                    Following arguments will be passed to the embedded script
EOH
}

MS_Check()
{
    OLD_PATH="$PATH"
    PATH=${GUESS_MD5_PATH:-"$OLD_PATH:/bin:/usr/bin:/sbin:/usr/local/ssl/bin:/usr/local/bin:/opt/openssl/bin"}
	MD5_ARG=""
    MD5_PATH=`exec <&- 2>&-; which md5sum || command -v md5sum || type md5sum`
    test -x "$MD5_PATH" || MD5_PATH=`exec <&- 2>&-; which md5 || command -v md5 || type md5`
	test -x "$MD5_PATH" || MD5_PATH=`exec <&- 2>&-; which digest || command -v digest || type digest`
    PATH="$OLD_PATH"

    if test x"$quiet" = xn; then
		MS_Printf "Verifying archive integrity..."
    fi
    offset=`head -n 532 "$1" | wc -c | tr -d " "`
    verb=$2
    i=1
    for s in $filesizes
    do
		crc=`echo $CRCsum | cut -d" " -f$i`
		if test -x "$MD5_PATH"; then
			if test x"`basename $MD5_PATH`" = xdigest; then
				MD5_ARG="-a md5"
			fi
			md5=`echo $MD5 | cut -d" " -f$i`
			if test x"$md5" = x00000000000000000000000000000000; then
				test x"$verb" = xy && echo " $1 does not contain an embedded MD5 checksum." >&2
			else
				md5sum=`MS_dd_Progress "$1" $offset $s | eval "$MD5_PATH $MD5_ARG" | cut -b-32`;
				if test x"$md5sum" != x"$md5"; then
					echo "Error in MD5 checksums: $md5sum is different from $md5" >&2
					exit 2
				else
					test x"$verb" = xy && MS_Printf " MD5 checksums are OK." >&2
				fi
				crc="0000000000"; verb=n
			fi
		fi
		if test x"$crc" = x0000000000; then
			test x"$verb" = xy && echo " $1 does not contain a CRC checksum." >&2
		else
			sum1=`MS_dd_Progress "$1" $offset $s | CMD_ENV=xpg4 cksum | awk '{print $1}'`
			if test x"$sum1" = x"$crc"; then
				test x"$verb" = xy && MS_Printf " CRC checksums are OK." >&2
			else
				echo "Error in checksums: $sum1 is different from $crc" >&2
				exit 2;
			fi
		fi
		i=`expr $i + 1`
		offset=`expr $offset + $s`
    done
    if test x"$quiet" = xn; then
		echo " All good."
    fi
}

UnTAR()
{
    if test x"$quiet" = xn; then
		tar $1vf - 2>&1 || { echo Extraction failed. > /dev/tty; kill -15 $$; }
    else

		tar $1f - 2>&1 || { echo Extraction failed. > /dev/tty; kill -15 $$; }
    fi
}

finish=true
xterm_loop=
noprogress=n
nox11=n
copy=none
ownership=y
verbose=n

initargs="$@"

while true
do
    case "$1" in
    -h | --help)
	MS_Help
	exit 0
	;;
    -q | --quiet)
	quiet=y
	noprogress=y
	shift
	;;
    --info)
	echo Identification: "$label"
	echo Target directory: "$targetdir"
	echo Uncompressed size: 428 KB
	echo Compression: gzip
	echo Date of packaging: Tue Jan 23 10:15:11 CST 2018
	echo Built with Makeself version 2.3.0 on darwin17
	echo Build command was: "./makeself/makeself.sh \\
    \"--notemp\" \\
    \"../../questions/potd3_003_petConstructor/potd-q3\" \\
    \"../../questions/potd3_003_petConstructor/clientFilesQuestion/potd-q3.sh\" \\
    \"Extracting potd-q3\" \\
    \"echo\" \\
    \"The initial files can be found in the newly created directory: potd-q3\""
	if test x"$script" != x; then
	    echo Script run after extraction:
	    echo "    " $script $scriptargs
	fi
	if test x"" = xcopy; then
		echo "Archive will copy itself to a temporary location"
	fi
	if test x"n" = xy; then
		echo "Root permissions required for extraction"
	fi
	if test x"y" = xy; then
	    echo "directory $targetdir is permanent"
	else
	    echo "$targetdir will be removed after extraction"
	fi
	exit 0
	;;
    --dumpconf)
	echo LABEL=\"$label\"
	echo SCRIPT=\"$script\"
	echo SCRIPTARGS=\"$scriptargs\"
	echo archdirname=\"potd-q3\"
	echo KEEP=y
	echo NOOVERWRITE=n
	echo COMPRESS=gzip
	echo filesizes=\"$filesizes\"
	echo CRCsum=\"$CRCsum\"
	echo MD5sum=\"$MD5\"
	echo OLDUSIZE=428
	echo OLDSKIP=533
	exit 0
	;;
    --lsm)
cat << EOLSM
No LSM.
EOLSM
	exit 0
	;;
    --list)
	echo Target directory: $targetdir
	offset=`head -n 532 "$0" | wc -c | tr -d " "`
	for s in $filesizes
	do
	    MS_dd "$0" $offset $s | eval "gzip -cd" | UnTAR t
	    offset=`expr $offset + $s`
	done
	exit 0
	;;
	--tar)
	offset=`head -n 532 "$0" | wc -c | tr -d " "`
	arg1="$2"
    if ! shift 2; then MS_Help; exit 1; fi
	for s in $filesizes
	do
	    MS_dd "$0" $offset $s | eval "gzip -cd" | tar "$arg1" - "$@"
	    offset=`expr $offset + $s`
	done
	exit 0
	;;
    --check)
	MS_Check "$0" y
	exit 0
	;;
    --confirm)
	verbose=y
	shift
	;;
	--noexec)
	script=""
	shift
	;;
    --keep)
	keep=y
	shift
	;;
    --target)
	keep=y
	targetdir=${2:-.}
    if ! shift 2; then MS_Help; exit 1; fi
	;;
    --noprogress)
	noprogress=y
	shift
	;;
    --nox11)
	nox11=y
	shift
	;;
    --nochown)
	ownership=n
	shift
	;;
    --nodiskspace)
	nodiskspace=y
	shift
	;;
    --xwin)
	if test "n" = n; then
		finish="echo Press Return to close this window...; read junk"
	fi
	xterm_loop=1
	shift
	;;
    --phase2)
	copy=phase2
	shift
	;;
    --)
	shift
	break ;;
    -*)
	echo Unrecognized flag : "$1" >&2
	MS_Help
	exit 1
	;;
    *)
	break ;;
    esac
done

if test x"$quiet" = xy -a x"$verbose" = xy; then
	echo Cannot be verbose and quiet at the same time. >&2
	exit 1
fi

if test x"n" = xy -a `id -u` -ne 0; then
	echo "Administrative privileges required for this archive (use su or sudo)" >&2
	exit 1	
fi

if test x"$copy" \!= xphase2; then
    MS_PrintLicense
fi

case "$copy" in
copy)
    tmpdir=$TMPROOT/makeself.$RANDOM.`date +"%y%m%d%H%M%S"`.$$
    mkdir "$tmpdir" || {
	echo "Could not create temporary directory $tmpdir" >&2
	exit 1
    }
    SCRIPT_COPY="$tmpdir/makeself"
    echo "Copying to a temporary location..." >&2
    cp "$0" "$SCRIPT_COPY"
    chmod +x "$SCRIPT_COPY"
    cd "$TMPROOT"
    exec "$SCRIPT_COPY" --phase2 -- $initargs
    ;;
phase2)
    finish="$finish ; rm -rf `dirname $0`"
    ;;
esac

if test x"$nox11" = xn; then
    if tty -s; then                 # Do we have a terminal?
	:
    else
        if test x"$DISPLAY" != x -a x"$xterm_loop" = x; then  # No, but do we have X?
            if xset q > /dev/null 2>&1; then # Check for valid DISPLAY variable
                GUESS_XTERMS="xterm gnome-terminal rxvt dtterm eterm Eterm xfce4-terminal lxterminal kvt konsole aterm terminology"
                for a in $GUESS_XTERMS; do
                    if type $a >/dev/null 2>&1; then
                        XTERM=$a
                        break
                    fi
                done
                chmod a+x $0 || echo Please add execution rights on $0
                if test `echo "$0" | cut -c1` = "/"; then # Spawn a terminal!
                    exec $XTERM -title "$label" -e "$0" --xwin "$initargs"
                else
                    exec $XTERM -title "$label" -e "./$0" --xwin "$initargs"
                fi
            fi
        fi
    fi
fi

if test x"$targetdir" = x.; then
    tmpdir="."
else
    if test x"$keep" = xy; then
	if test x"$nooverwrite" = xy && test -d "$targetdir"; then
            echo "Target directory $targetdir already exists, aborting." >&2
            exit 1
	fi
	if test x"$quiet" = xn; then
	    echo "Creating directory $targetdir" >&2
	fi
	tmpdir="$targetdir"
	dashp="-p"
    else
	tmpdir="$TMPROOT/selfgz$$$RANDOM"
	dashp=""
    fi
    mkdir $dashp $tmpdir || {
	echo 'Cannot create target directory' $tmpdir >&2
	echo 'You should try option --target dir' >&2
	eval $finish
	exit 1
    }
fi

location="`pwd`"
if test x"$SETUP_NOCHECK" != x1; then
    MS_Check "$0"
fi
offset=`head -n 532 "$0" | wc -c | tr -d " "`

if test x"$verbose" = xy; then
	MS_Printf "About to extract 428 KB in $tmpdir ... Proceed ? [Y/n] "
	read yn
	if test x"$yn" = xn; then
		eval $finish; exit 1
	fi
fi

if test x"$quiet" = xn; then
	MS_Printf "Uncompressing $label"
fi
res=3
if test x"$keep" = xn; then
    trap 'echo Signal caught, cleaning up >&2; cd $TMPROOT; /bin/rm -rf $tmpdir; eval $finish; exit 15' 1 2 3 15
fi

if test x"$nodiskspace" = xn; then
    leftspace=`MS_diskspace $tmpdir`
    if test -n "$leftspace"; then
        if test "$leftspace" -lt 428; then
            echo
            echo "Not enough space left in "`dirname $tmpdir`" ($leftspace KB) to decompress $0 (428 KB)" >&2
            echo "Use --nodiskspace option to skip this check and proceed anyway" >&2
            if test x"$keep" = xn; then
                echo "Consider setting TMPDIR to a directory with more free space."
            fi
            eval $finish; exit 1
        fi
    fi
fi

for s in $filesizes
do
    if MS_dd_Progress "$0" $offset $s | eval "gzip -cd" | ( cd "$tmpdir"; umask $ORIG_UMASK ; UnTAR xp ) 1>/dev/null; then
		if test x"$ownership" = xy; then
			(PATH=/usr/xpg4/bin:$PATH; cd "$tmpdir"; chown -R `id -u` .;  chgrp -R `id -g` .)
		fi
    else
		echo >&2
		echo "Unable to decompress $0" >&2
		eval $finish; exit 1
    fi
    offset=`expr $offset + $s`
done
if test x"$quiet" = xn; then
	echo
fi

cd "$tmpdir"
res=0
if test x"$script" != x; then
    if test x"$verbose" = x"y"; then
		MS_Printf "OK to execute: $script $scriptargs $* ? [Y/n] "
		read yn
		if test x"$yn" = x -o x"$yn" = xy -o x"$yn" = xY; then
			eval "\"$script\" $scriptargs \"\$@\""; res=$?;
		fi
    else
		eval "\"$script\" $scriptargs \"\$@\""; res=$?
    fi
    if test "$res" -ne 0; then
		test x"$verbose" = xy && echo "The program '$script' returned an error code ($res)" >&2
    fi
fi
if test x"$keep" = xn; then
    cd $TMPROOT
    /bin/rm -rf $tmpdir
fi
eval $finish; exit $res
� �_gZ�{{۶�8��
�}סY����G�u�"+�v}[Inҧ�Ç�h�'�%);��>����� �����-��`0�\Z����loo�������w��+���8;/w��ag����;;���o����~�i�'��ǹ?�XR�]\�w�!��I~Z�A֚,_v�x��>�����������7g������|F��r8{i���egM<YGθZ_[[���y�.�I��twm��s�t�9��2q&q՗�,��P�*H�'kk�q8uN���N�� ��'
n�k������>��v�U|��F��3�q&ٕw�	����b���Bn���|���Y���M$Vdc|�Pf�	�K�[Z%	�e�n���^���{fJ����x��y'��9�X�����M�ZW_P�����^�����v�o����kΦ���	����Z;��� �ςi�y���׭�W[�s^����Z/~����Hɭ{����0u.��?u΃ r�ArL��$�;��,�6�A����Yু3����L�́��aL��-�L��M�˫�q'
�`,��v��?����^�t<89��I���8mfǼ������
���&��_���,�� �:8���i���p0�;u���T�w`2�Â_8�1�"�A}��`˙��n�޳g;;�w^���"N�~�-��VTB�cX=.��,�A�\@A��[�aI��z��;;������x��8���l��W�8������	!V-��\]�m8��#|��;9 D̀0�M&f����M�LAm#
��%�Aˮ�ijih0���gG ���v�z(��J�g���b�D�P�f�uxr����$��0�We{'?����A�VD�������wv<����'o���<e�7��܄� ��t�ec�����ٛ7�B��jyq1�����Ӿ7vcTd>�5zY⇠����k���F���v�N��
E�/@#]��
��2�kta�9�}�`�l�<T�k
S�0��m��j��
\�����S�m���f.�g���
�ώ�v��V���;��]
�W�����H�"M)���M �s��#�������|��~~k����O��e��S.Ɣjr�a���G5�4��jL��R��O\����� Cv�/�>��i���U�����]���Q�t��|������q��s��C���VmeWa��N�E�5a$���x���a��UN�/1V��Xa����a���G�KBC~�%��͑�/�#�~ixh��*�e��Jq�'i���Q�&�ї��-��ٙ�>�����r66�����	j�������,��>����?���χ�<��,+����rr�~R�I�	�tb�q�6+ ��<�"�|ĳ��/0�Tzs:|	���KsP�ݏF=d��l�LI�&ډ���ѝ���D�K������i��m{�.�z��9;/����}�Q�1]q�Q����U���j��6yy�sc��<�Lr��s�0j��|�m�R��!�O��I+�mx=ɏ1A��a~�]�% �
�|%UF�^.y)k�
��X�|��/I�ѳJ�*Z�w���/ԭ(�E�;X�ɑ��ǯA�8y@Z�;�-t灏�q�M�6Z�~^�	V>�u|�?��u�Q��-<l�蹘?���Iڀ��>���s���i�Eq�,�x$�[P1�錶f-j�e�q@�hB���εΈ��*�]Y�X�@Ȓ!c;�9��5ذn��ruP(��껪�[guZ�x��JK*��]=p�	k9
�
ʥ��!��沀�����Üb�BM>Aa�;~�.a�fW0W�Q�IXQ�E�����e���g��E(R���/���R���
�D��M:z�a]z�Y�5,�XR��U�8�WԵp�+��Q�����vmm��g��G�+�QaL�۳� ������3Zঁdv��7n���i�P5<�w_�/8�AC�%����4.�è��=�fCAצ��]	�ь
�{6>�7�3vԔ.��7�ؐ2��F{���R.�Hm��q�����/\b|�tfX�A�|�~�A�Z{f�q�A�����n�7+kcŹ���7�H鈌�C+�7?i�O����V��+��I��i��\r���g�1h�W�p-w���X���
5r=r��<��i0B/�,������]�! �,�a~Ҧ�r��w��?�5����#��B�8�j�W�Ï���*����PK��g�Ż� 6
�+l8���莺�Xй/ �N�rs]J��E�4���`k��M%ڑ��o8��ċ�0!���RJ�2���a�_��xƸh�<�����F� ^�./�no�4Jpe)��hzEo��� ���9�p��W^C�W�aު��ߝ��
��S(�f���c1�8�?s��)a�������fLW���^p���i�ɶ��օ���=��v!��O�=i�v\��������Ó���S����s���Id�>�oóA���ڰס{0:4�q��4��,�l�oƿ+�R�b��|�f�u��5�QSm�oCY���\���ʩuw���@U�@ ��U�1��w8Q��эP5��h ��=�c=��X��N� TƃOY�G= �0��O� ��s��
�}���n0��d8RZ+�-�:@{��f�b�?����E��5���c�����v���\Yo���� ��ӊ��J������q�Ge��R��\�rj6����5|����Ǳ��J޷"������Q6�,,��`V�R��ae���4��a't�D��'^�L��6��a 	���H簗�������?g����n�����z]�q��0�j�D�P=n���r0�B/<GL��ŝ�R���5�:��o�]��mRC:��2�x��e�����"^��F;K�x�����u1��z���"����n�N��	�L1$YV��V�������B7m'G�Hm	��A�Lm$���1���0�nU�zM�φ{�X��M�N�b���C��ٔiW D��z"�5PN)��w3?���7E�N��VZ��>1��}��RmQQ:r�A'5(���D!?�W&���t2�bn\�Tjk�Rť�4-�d$�|���B�\vZVh�H�B����#�P5�:ʹ�xÄd2q�m"k��΁g�����zV�'[[Yb� W��>a���2#���s�����`��V,�tqB=/Fw��,���UXl���\����j�b�[���V^��Cԥ�]�ʼ�Y{S�#BEybS?��hUT��*����V腴Zg�lT���k���i�T�3�ѻ��t�*MT+�G�#u1HQ�@�5��$�Ǡ0J���F�O>d	�[U���D$��ʠ��.nH[��1�f2��G<Q<[h��c�>�b�@�W����E��j��%�%j����������F�����o�WllB����uG}˦�:��0��l�&s	�����fn	���c����l �
E���4�[�0��j�j
�q��E�DT�<!�$7��o��P�X�:8C��䲺V��*7{�����q�T�Ť��i/�rMF�i�ZJP;f�H�K�hJ%V=((����-3��iT�`�5\g#G�r��wE�����^w�vD/<w�;{W���S��n����)#�?=����;�2������"��k_�ŨQ�ץ{�v��`�/�`J%S��� �*ൾ��|WxZ�UeW��`��?B.��bçȇ�X �=ƨ��+�����J����d�����Np�p$��ncsM�;�c��I#EQ,���<�nax���%�SR��Ȣ%��$����`I���ak��"%w�����jP�������AZ���_F���Fu=�|*�ܑ��n�
ZH>i߿�B�1����U]�D'�W�MTd�����i*:
ߖ��8��t}����R7�ӄ^AV݋����a�����Η�l$�a�����{}68<��y�|<���DM�!�
����F.�V�>�Q6F�d[a�Ù?#f��X �BCdMwQW}SN>��Ѥ�C>�	\���\]"V���Ȏ�j���L3j8�&.3�25�E_ (�ɜ\�ȃ0��7H@�T53�T�3(-�Y2�O����t{G"<�ʇ�28�r&�"/��0u.��C���e���ɒ� �4��y"�ԫ���cbh�c6��HO�g%ۦ ~���|8�e�B��1��EQ�
�~�Xظ���R���i�\_�1����J1`&x2#�~7��-��
2c�W�r6-��ʥx�O�t�Ի"�4Фo{�8%Z�굜���E�W�yL=�ۢy���@}(H*�3�Ww4�1�"[���0wǃ����7�c����'��L����n�#?�%�$L�rU�z�Ca��c	�h3�2�5G�`\C�V
�l��j3G�
W��^O)sI�k��9�f�NJ,�s�!q����S��ζ�ʃ��cB	�L���Gt�Lx�V ���\2�A)R�d��h�m�ϓ&|������7����������������k��E\���/&�+�J0h
.}b�G��Ě�?��꽋+3̢	ȕ
Q�
0�������"���������
;��M�|4:\cǘ��Ǉ��t��u)VC�3��%=V���8J�ؚZ��2m�N,��n:;M����L ���N�v�X�Έ6g�"��f�Ɓ3{�0}ڂR�s�}��4�[� sm%����=t)m>��¾�HAMM&���j�d�u���r��]��5���g	�M�/2Q	������Z0�jP���55�P+�U�H�r i�2�.'� ��?���ȴ¡k,�Wj ���(ϋe��)���W�Zt��U��M��%�U�X��iP�>a�s9T<n:�e�4
67UR̽P�dM�bεg�R/d�����������1 �rkT<�ʟ1�L��/���d�m5�\�;\�&p������jU��U��VYS��yG�"�r��W��i+D1���U2jf��ćF�cV��#��ur�8�a�3q^� iz-]q�;U�Q�_�@�U52
�1���eS�H�ˉ�O5m0�f��n��=O��	�a�1�� M�U��VC�`A��������L
�eF�4K*0��"�����xTS�)ǮŃ�<��WP�5u�*OS�
2�6���;M@|6�$� T޹?��:Ơ7��6\eO^^�J���\�J�
N����H����0)�=Y������j�C�]��jɟ[��K�
W�Gto��j{8%��c�����M��f�А\�ŀJ�F�J,)B���[�\zo_6�$�A�ZV!��F�-g�����=���c���s��a�q��a���m�����2E�K9�>�WҮ�#�<���e�]{$[yu�'���(�g`���\�F
٘��4�N0}������FvJa�;�Ю�ٴ�-�~g�����D0Qsx��V�YB8�����{RC���*ʢ�+�㳠�b����`#"@��9Η����Ͱ��O��aj�.j>	��z����	vd<r7�c�*Mmu!��{aʦh������O�XF�2��q�/���
���6!��f�ϵ!�5 �Sxw���ӬSL�)���_d���%�p6	��rD��'� �ܶ�f,�k�7��4f� �փ�c��ݨ�#t��M%����g�qߒz�h��~�|�,�9����yk��t�8b�W/�[	�t�)�K4��s�}��-K �  zqt����.t@��C��$ �@ʌ8#:n��0 ??����	w"SJ�-�& S�{�r��sX�:=u��z�t����5���A
�{��C�1)��[r��yѓ� G�#ޛ�|O�z�?'~���#$�[#8�X�ᴸ�����:F*��Y��t�ܫ���[ˇ��zkOVm��W�>}�[�1i�;+7ֹg��uV������7X�k��Z�$�Id�+��LJ�H�-G��F��h�\���"K0��r����9h*S=xE\*Q;�n��WD*;���[����_��(*Ia�f�㡌)Q��f��S	s��ҏ�R{K��t�#V�U
�d�,��·TlgD֋rj~ܒ������9t�M��*A��$cVd'u0�Iy��>]� Hog�<P��k�6�;�F5~�td�'��Ee'1*,%}������!I�}���̱l5�-��ؽ������J�RK�K���!gn����x����I��b�d9���9+����W�^.��V���Zߔu�ku��GtOZ��Z?�>���ܫ�K��)w��g�y^,f���+���.R~��ӂ�!��7�rq\3'���v&
�`�Sja�%�l������/	�l���#�QgGrUX}���� �! ��_�:7��$p��$h��T�Q�
� �jg�[�k�Y��v��7+U�mt��
+%�n���լ�Zi�'UQ5�k �N�%���U������`�J^�v�u{��uXc��+�+��Z�zfsm�d6Hd��`���`!I���i��T�hר�Y��+�뙨FȽ������*��2�e�����&����P�=u
��(��H~��m�[m�r4�G�����l.���B�Ցn�bF��"9D�x����O�i�ޞ
����SH�_j�:8H)
�D�+ؖ(

�I�y4�D�����^��l�$m_��eO!�D�t����|JF
����8�k�2��o��"M%�M�P�c�V[�V�T)AھXgC EW?�U��4DJ��ؚm﨏�C�?��n���W�\�� �k6���p-�8��ig��Mg��`<Yh�Ҹ�*�R�2e"J�x7
���6h����-N�̔׸8�����;�Mg�iÿu=�#�2�2���;.iP
c�9�Et	�Ӎ�LS�ʄJ�xn9��w�%�0ڐ��tg)I�|
����:1Np�f��a�q�����ˮ����#9�R����Z��	�"�ܹ��{r��2��9�=� o�%�=���5c��pJ<(c� �A��R=�̘��1�f�2���,G�E���Go�H��.ܝMZM�GE�?{F��j�wś�.�c�L���
=3�]��ee1\f���*7�MC�m��B��=��S��$k�)���A#F��QL
��
�	3�HZ�\�ݦ���T���T�Ps1z��7Rj��q�
,�Phb��ӄlÏE��F����a#���f�^�%C´�f� 0v�oʢ�%>]k�ie4m	�тcZywM�G�s�r��p�v%�O�l��'j�L�&!��d�:��7&*,�GS���.h���VN����j��.�A&;����@�J	PȎ�e�����2ʞٕrZ��mu��d����1!MY�<C�˞�j���0G��Ja4u��=��9�vn��Ԩ�w穃��Ȯ"���>|mț�kÖ��ԑ�l��	Z^/�R��H��]zR��٭�OњKҰ��!0HRh�
u �%J�3���>���c�׈���V^�ۮ-��쒄�~'���`%i��e�V��uB�*���D6�<Q������I�����,�X�����*�mL�cW���@��@H�'v���-X��B[P8LmdJ�]E
�騔gN��#�2k�ESW&��B�\��Pe����1�+�P�b$:W�I��v9�v��Ͳ��=�8[C�W��/�5���ZK���R�")$`!�����nΐ�K.�io< �9�Gefpr�ܱ��?u��m~m4�xUJܜķ�Ț?uuȍ�����N�P�N���RU.3\�i�y�zb �
l(���f13���d��X�p��r�RE���L�q߄2����];�a�ifF�\dO0'�Qʸ:'���������M�|.%gQk�����r��*����n�<�X�����?|�����}�:�<�i�����>�r(N!�bZn�B�Gڞ��i�D�]7��U3A�|вC
�k-���a�y,B?��h_��c�{| {��qy��
%�K�R���]�"���6Uh�,~D�3��ǤL�4���D΂O��zY�\s6�I��Q�Xy�6/{�e����x�7av5����$�?��������1��h.�V>��� Pg�b1���h�٘K35��x�=��ka)�<?�{��>�d����5J'�FQ��5b�^��~|����pm������7דm����̪k�O��_�������yD�Y��K��
�����Ir<Ü��W$�?���z�w�O��ED�;��v�n�8܄3<i���Xo������$>Y�+�	�Q�j�'~rKJ�k�F]T]�
��~�,5��)�<���eS�q���HκǨ��D[S��Ė+��=�� �F�G0�S�{�}/�[+��������H��u�yg��U'�����+s��
��MD��*S�>+?������}��m����^[OF�
o�-���j8ư� b/T�
|Ң(��b����j�@1�
��@�Z+���Z��Z�<3�|��߭�6�0����Qi�:�l��������ro�����]X�X��i�R_'���clZs��
��g��~�٢�ASN]	�a��̍�Mң�u�e�7����c㟜]D�r~��&&VM-�Wdn ��[�쐔w\z�]���W��1M%�A:IBzp��K�R��u#��W~#A���	2�ݩ@2��5yzy����pz8��Q�����t����#UL�hGDW��Z�
����"�ny���$�0���$FU[�BY��{�C%�MW��G�
���C�0�b�zs0C��O����T�)�,Ѩ#�Y��/Q��UQPF��#�x�Pdss�VNLj:�vU�$�6羹����'�l��r%�>�l���$/ �c{��t�4�Ū��D>��u
*�AS��b�
��_�Q���A\e�S=��|1T�b)ے�aM+�")�MD9�"�W��޸��P�ja4����,`6>p��
銃�Urs�@�)�N1<ǜf���2���}�5jz�0�f~!�~{��i1s(0%�OGԩ�~�Ĳ�@��2���[�����P���t��k\��~�b*�y8�#���Y��lM��m�U�q4/`�Ke/��O`���\��,�#?*�JX_LH�A�F�*'��[VN<�%
i��*k�_F��a�gAtg3d��j�ug����Zq��ـ0�����O��H�r�ԭ�L]5���&�B�ٛ4�G�y!϶f$���-��8�a#��'��r�$��2�qQA�����Z#̬�M�8b)ǃ�0+�,)#��gMol�/���g9��P���\8`�&U̥��Ȗ���Gil:��~
S�ƣl9
����?Qw��,��<St�(�3'kN��kA�Ŵ)'�ĩҲ%A��Y��Y*R˥a����gZ��u���?��7�2��.��!$W�or�(��U}P52��5ɕNHr\�����.�oD�<��
⡔rH�5~�r������/&{��>{G�����R O�*�鍊�9պʶ|-i���rI�)�$�l�V���Z"��G�|�v�~Qe�d�I���gǾȬ�q�߿���-�_����K�q�)�hx��[�3���O˸U7���b8ؓ$��2�.���CA�!H���.���!��V��+�Y[e'S}���i)�(�{38�{���[���Gr ��X�g�#�#&ϵC��?���ß��3~�V/@
�  �ֻZ����; j��;{���)�:d��o���T�t�|X��S��߳T�o��HN��ؿ��B?ͫju��w�ss���1Pe5~NL���W�Ĕ 鯪 i}�!i�*b!��!�W��5D6�d?Z� �U�/3�a��������fɞ�4"���^咷u��1J��đv�l�C̥YeOB���`Fi����z`�	�㛦1:�٬��l	�)ƜM�؃�s
dufӎcx�V7f�|�r��g��kD�p�֬[�O�;cm�]q�v1�^�i��bÒ�b�����Po�
I�
yjI�*,�ju��B����XJe"�W��L,�h�����MG����u�	��Xs�^>���'��v�i�q�n�)Fs�>�)I-1I�����4M��������;�:�ǉ� �,��<t�;���<t�;�F[͋b_*�F��u�2���IY��մ
u9�*N!�U+�T��Ƴ�|�޾��2�XuWZ�;�䡽޻w���UW����ޫ+�'
�Q��T�<
:�T�F�~�{v�����ĭ\H�K�Vt/���#���#vPh������&;Oț�s�b�Z�|_�Wxvt��Ӹ)!am�j.�� C��s�u���xGZR���X7"
���r4(�ԣo-�R	�e|k�B� ��T�A�ݻ�CL� =
�3���K�>�w��n3&��ǝ��m���Խ�񮹯��Y�/�u�`m3tOŎ�:'e�9�L!�������F�GVgVa�z<�
�r�CM�Oh�g���	wk;�r6C�,�%�<;<T���L�����(���'4�����\�	��Ü�S�|��a%�nhp�׆Zrό��T�/�� s��	�J"����k@��l����嘍[�ƕ,v:m��J�B�F�f3�cjE�qII�!�-�+ﴙo4i�0j�Eb*�:�W!�s�9�~N�MDHt@��+�x�޲�z�J�F�MQo�#7h��L��zZ����d�N���Ѹ,�JͿk��,�2�lf�xT �O+=KHG��u*��Vje@���#�"x
���/�}�/�q�:}��U��a�/F�(��Sy�ǋvrf
��2�e�)�Q�����D��p5#��2
�)�*$���I!0/��2iSpH��tz���بȞ��M�]1�z�|n��~a�	c��u�10p�	])��H�鍿�{�Q�yk0߷�����
�~E	e�TJ�nF�W�:2�*�x���i��`�H�r�R3�O�Z��.�e1|���/�ҟW;y�=�U������T !0=�c�9{X�y��0QI�a8�,�_��nt+.�H���S� Q��9�@���!��HD��$�|��k�CN ު����L"��`���Ml-1����9�7�&��e�:D9�#�EzI/���ET����c�Lф �wq!f�	��xJg~��Z��h�d�&��8����߯�m�(d�$�-v��,��V�� �TDi<���s	?����|1�g�gs�^�uz�d���KX2�k��,��J��^ʇ^J�8U�G%S`�Y��B`�[��oP)�~�lrA����	#�(���!4���;�`��Otʫ���V%o�mT��O&�S$<�Y�S�bw*FDK�K��PLR`�H7T٭A�, �v�(�|zl�H�P*-kH^_����5�����fgD��M�N�H8�?������Y��dFy�����M
�o���"���s8M���rz�p6|�/�m��s�����'�F`p//MJ��YG��MM.�OR�U�?��Z�3	M_�!�QhK�Ja�H�\uw���r���D�i ��}�n.ߑ�7u��ɕ[Yz={f.xW#0�E��^���J�M��\`-^��h|�ݚ���.�M��bY���\͕o2Q���g�/�)ʨ�H��rp
N�vZ�+⓭�&��\�5��,<2�������J�
ls(��4�3V�մ�
S�/y������9�]{&Е$ӣ������k�v������ne��Q�ڑ`#�6��W�p�1�&.��}��>:=$�U�#�d��+$�g}��3�ß�S�e��Ѱ�'~�[R��P���'�G^o8>x�V�]�d��K�3�w,���o%�}��9���/xv1�/�}��%�(��/���5�
:���~�;�G}�����÷��M8�N�d
Ð!KU�������0�q�&� ����*���<�TB�g���uN�ӡ�6��$/P4��o���Т�V�&�a{�:ήP��2:��U(�t<k:T�_�-��Qִt�{�XAO4����	Z(��(��m�N�=T���Jo�<ѿ��O-�G��	��D�=Vލ�8��� ~�Џ�����xoUc,grй���e5�sj܆�	�����9A�VE��cU��xr� k"��i��[���
�Yv��6��
M�Ei'#�x���)t�% �.qh-�7�V���آ9��H����t-y}��9	A���<oX�G�FGP^x`���ޜ�L n��2�n���
%�BqP�����#�U�٧ٗN�78
WUr�z'_R�][��3l����M��|Eb�O ��xh��А=>}i�ڳ�Ȑ!W� �y ��m)�wta�',.		�Y��p_�e�5��s��Pw��eK/K���O)o������t��Ev�6L�΃�9#W<$-�B����>�u�y_�.�itc��0[e���f����y�n��^wJN�T��>@��Hژ~D�g���3oӡ֋�����٫�1�N?���DV��&�(�?����P��oGj����a;G6RqjS���r�Hg	; ��@NUO6�u��/��4��^,��,������o�E�9�[f�Jx��J�C�U �ÿ���MT�x�X�\Լ���p���������7B6~<�3�iG�`҂���ҥ����`W� ��d���yC��Y���{�I)l }�0�8�V Ỵ�/��o&N�}縸� ��S����|'m:n�p0��Y0�&)#[@�����nU9h-c4 ���oZ|�)��~x��y�fxZk���i[cC"�+j�"�������MR9&x�V}�V]��P~�5C����ik-�6x��� ��a
���4�e�/S{����X�Ψ��Tی�ՙ���z��%W��A�	��A.�KMw��D���3����2=�����6�_�RK�K����@q�i�텟��CW�/IcMErZnꪥ���?��#�sZ��e���B>k�QB~}�>Yc���P�Yjj�D�����;&m{ђ�.�	d�6ZQ�6��w�I��`�yR�pِ�ze+ߨ+"B[�T�}��V\ʲ](3�2� �o�6BL*U�Ԉ#R��6YP+��m�y�{m�v'R�cn^T3�1�32Z��qzq3�<�⊝v�$�xyv���3ׁ�
x�,3�X���2��T(��36�z���~u��eƛx��lr���p���i{[�MS�j�A���K����`I������ K�PE�M�P#� ɛ��n�[)��1!���.#�B�� ��$�{� :�e(J�eSzw|
'�e�/�?+�®;���f$�Ҡ��e±�9H���8�	�e��tT�T�z�s��3�W��hN��reg^�R���+�J�$�4(����n������i�2:MF�	���b9)�s�Q5%�����%�L�Q�π�0ES��+���ڽ��C
�!��q���럎�F��!��y0��۲EQ�=��\c��I"D���/�X�#.�L�[]��b��Y�b���i��
ꖹXݲ��w�lQ�ZR�̅��K�i	�$u�Ash�-WZ0F������|K��o���ˢ:	L(����(C�r�NW��{��\3S47}s��ʕ,Y�-�%]�^��+At�c���fP��H��-�PoW�O�X�0��q�`�K��vה�g9C��L��TMb ���%Y��C�㜧�������l�V��+��-��cr����hw�pϋ$�!�G�%6
L�O;�٭.�{�!³�t*o�:�i�x�w�r�p7̶���W-�E
��ur;�,��b��"���C7�+�$U0�U�W�R(L5s���z��9j�Os�f&��򳍡,�
�U�K��M�<�-� 8�fhh������6�^lh�ֱ��)��\w�1����z$�͇���@di?Q�����H{��!v~��N�����Ùlh�B��٬��@�|Z�Y(�����S���V�<���Fn�>�A[/7fG��Gc�6n��4��a$��&�$��H�q*�i/3�ge��+����X-9X�v$���t$Y�(�2י%
�k�ߠ��î~'"��~��H�1�:�0��4���r�p��M@���uh4W/`�ie
��9�-�����6�(�)-�0�.�
�O��;!�pF
I�P(�u�����R<����i�W���w
I����s���O�-V����0*y����W���Ѵ�;)K��<Y[�ٴ�Fo��oP� 	�}:k3����Fh(�{���
<Q�z@��[��}�Ɗ���챶��6L�ѭ�h�����m��y��V�<.����N������A�89��1��{E}s�PWW���IB�]�߶T=��c/� DC�t��5`��MۉF$7(�@hܠ��٫{�t����n�ٹK�з���nRI�L�6+0	f����ĨE;y�<��
ڝF]X\ը��
�U��@���Ҥ�{߇�5�"?��`;��i���y�/�bbX.*x+�+�m�g�Ƚ��tɃ�Q�{P��$f�h2�T��8g���S髐�s�&�ו��~Y���&/��͈�*��_�@�<������W�������ޓ���� ixq�F\��
TQ����)�z:���?dw���M5_���䂵���2�����gO?��o�<�z;���Uց��2�
&���%�?������@�Do Xʛa�|a��3�UR^3��$<x�����h���"��j<-�����.j�T���?$F����ƈ�@0�����9�|�H�m�1Ul��^ �Ď�J�W|@���$�g��P�do��uG`Nk�#��e�[i^b��N�]Љ�y�g�۸�)1%�͕sGN�3{oY�y��Or�[�`�Ç,�M��C�C�$����B����	Ú=ɳ;O�82'6"L�
+R$�5�nTqo���\���n;�P�]�O�x��?S�y�h���I|�y=�h� ]2 M�Q~SM0ڼ����%ŕ�5׉��1#'���.�V��ѕ-L��0(��Ҥ`��\W�&G��l��Q��"��§� D[�F�Ԩ�Ib&�99��pRo��B6�����$:�ؒ3
��a(�ˤ��9�%����V�r�q|u5�����VF3���j��@��t&;(x�J����U��Y	��m���W�*[��n9�X��o��84�c� a�w^=��\Y�);� ����P�����ٝ�:��;-����Q�@�Ùi�{��1����
~׆��/(��
�{ ]'��B�Գ|T\���l���yb"����dƋ�wr���Jp�A�`]�����,ԍG���l�[��͹fڬ.ٷ�錋��ƫ�7��z�#�<6��8���
�"���7�N�=�A�|a� �61ŵ�ƀ�P�v�xGi��$�:x�,�S�m�uE�j��FC�0�?]��`e	̘P)�"�,l��y��eq�L�����حm��=�/���
�'������8=C
�I�qO��>�|�KytfNg��k�T#[E�'9�ee
҄����˿A�K&�p����4%�g���2�R�?s➌���&m��8^h[����������Y��6�r��V	����j���{Uw,E�� �q"������m02���z�z�6�6v�*������i{�U7v�VS�U�k�����F4A(G@�V��^q��K��yq����z8{����HFN�g[g�Y��cS��4�[�S�Wi=斛Pl:�)�oD�N����R)�_���fvZ��N�u�0v3��QðTǶg� �c���Ǔ_ى�����̼�պ�]���I �J+M���WՈ���aѽ�hٵ@,Zp����6ʍ�@-;Ϭ���k	嬷c3�k _��Mh�j0��	Ea���T8\�d&�ϟd%����m��ߢ9p������P���-JȐ.�k����,+橂БA��n����B�j�>�~A����q����c�B?p�[���_m�x:�6��]@h��UtC_���p�fU겴_w�d,By3��Ǟ�2�j��L8����Z��dn�T����ՃtW�O���{�)M���.ﮉ7c_!A��ޤ�;t�×2c�D�
�F?��2���P�{oPżkri��O�
b�!y��ܬWyЛ�ה��G
>�N��5;=����š�qY6�W���`�0��-�����lf���f-��@�tam�m:�M#�hT��}�<8�p6gD��5���Բ��*.�o^qQ�L�9�s�JY�	�[qn�+�e5_�_�����e>��2����Ϯ����# �B����x�7v������Y<�r���|�~�n��6�f3�7Y��#�W�
i���!�x�
m:�Mމ�d�h�!1�HH� Ä��f��9X�30��$��:�$u�OR����8N��������sdA��"O��`�2�]��+�'~O���ٰ��!��7��o�����n��/0�k��p��8�$�A�e���,��7���jEO:�Cf[.��r6�> �U2���y��
��gz�\&�n���dq~j�-�g-7����4>�0�`�?�ǟ��c��cy�kb�]���^a;x�M\-�$�f˲�'v��T�F�S�.:<�H�|4�y�h`�?p�d�z'���
���'�Z���UW�u@	!�+�L�%��;��ӵN��5��s6A��?I��p������%���U��Hn��9DԂ�32u����>�U9�{�|)h!� j"E`��9z�k#q&�rK�QH��*'#ݪ�5�u�Ry+�GQ������&���@IKm�����|��XG\�	[�+~��.�1�z���U|��=�C�p�F'���j\��.6K�y>�c&8?���q�����R�zi���%	�M�4)T�I�I6���s�|�� v*d�hU;���f��~V���㣋��3��L���7/mp����R��9�!����|%&_{�G棃��.�ӏ��s��-&�B����ϧgq9���E��
��k?hgʆ�����o�j�J�ujnƟ��:��@1Z��⟇୞����Q�-L̒Z���~���f6�h��16[;����t����N���XjU��ͧ��
�����ڸ�{��י)S����0����bQd��p"�8氼�����0q�ye��`�qʎ(<���P�>$�mt��Ddl���ZH��X[��]��!�X2�N�2Y�5}���^��\�l@Dk-5j �
��}	�P���@�b՞��w���[��ٷb���q�������k"�.f15�{�����lf%��a21 �w+���*t�"���n�����I��1V�D����� �~*`���orvr�7����I���u��G���@���u�������_ۃ8b_�9yz��$�����ù��^�Qwm"�\�����M�	Ez��-�&�Q���a!����?���\E��Rs�j�z�[�O�7�'�BL�\z�o9��d������˗/��#�����vv��s;J����@�[� �=��$"�91E&����H��D��
�le|����4퀉lG�:��!k�!c(�� zu�r��IŪ� ��,�W���?�Iڊ��)���f��B�~����b&ǪA- �i�RO�6�8���!��1��1�?��_\��	ߔm�p��!x����o��U���X�vս)��]5{j*�1�=�l��)�n�V���f�='����a�_eڞl&�@������F_iP��GG�)N�gΘ�"1漺��b��I�\W����v��b�M�6�o��b̭Ӳ-m�,������Zx�
{�<�v�R4h����/�B�h�O��SC#�E�����U�
����T��Y��v��ޛ���ylP<�n�*���_��<R��?�4=H
��{PC�,�.��$ُ)�0��j�~\�(m���c�Z��]�P��<���y9�^6����&7�`|��36u��.d�,{�S�l��| "S�@�8���c6���`��[~� ��C!ef�47�e¼�7�'O�[
�j�\���#5���7���
&�D�tzo� T"�l�Η�QyUY/ܪ�~��G=d�������*B�}�����ZΜ�UY�{�D29���5�.�m+���Rv O��gC�=�fwd5�NC]y�ț8g�a��\x�e;����T�梛~ڵ��A_̻����=8�u̠Z0��s��^.���ҷ��]�6&nU�aJ����qz��l B�ٝzhD����ר6�)` ���Z�^�d7�<�O�5��c�{P^^V*w�9ڑ~�F�
���JԹ`R��7P��5`l>%_ ���,v���]9���~�J
�����9�-�أ��۵�&��=��}�'�1zpv�����ś!�{��ԸR�r-K�l�F����R���Z�F�45�����4�y��4G�,�J4g�-����B�p�mS��j
G�in��L`�y�_狷:ͰջĒz�`ͬ7	�)�= �L/��yZ�25�ʮy8�����aƷ0�����,��4��6��&��Xg���\�d��V�:�PQXW�^��������Y�.H0�aT&�M�k�ȇ�ȡ�BT
����
��G
4�t�g��3���Wd.b X��Ϩ�f�X�_�;uLq����YV�m:�!
�C��8	�*�0���i"��5�F&������$IB`N����D�R�UV�z���z��O�Kl�ߦ?"Cw�K;��+oB�6�B��-"�p�U�#�5/�ǀ�0�����`�"�_8*�Ϋ�~x*�8�Y��1���I	1�+�&7>:�=g׭�n�6wY���J>/��i��¢YB�P��
�l��½��u�WR��v���?-/�Zc����������`��$������| >�n�߀����K[��I��~c~a���}�J�<W�+���_[�O��B'����zz">�ļ����ܘ�ǁl�Ɏ�6;��� M�ľ��
�,�#�ϗ%�5�����L�?����>���������y6��7�L^؟�������aSȧ�X ntҽi�����R{kkF쁓����ǳ��Ë��������������5ֈ�#.|3ܪ��.@������F g����� !�&*�&��q�9P�n���(��wٝ�Ψ��iӐ��

!`!�z��U]�:a��e,�k�ίa�`Nm�����X�|4y*�
L�����k�;�o�� �0�Q��!�f;	|��-Oy�I
��T$	[SM�����$�!\�~�����=na7�؅Շ�6c�o!.Y{^
0�(0j)D94bz1���X��%HP"'��E-(	=��
�"�)����n�{
6�CV����x��z(�/�g3K�,u��أL
HFf^�6���F��z��H$g!` �i��בU/�B��b=�����
��2�[�ҌMܖ�:�뎁-��y�L����� ��"�c��ꇮ�0g����݇��?���=AҸo}7j�yBY׃�~s�q�������k��uW[��g��nt�̩n윺����޾�X��p���o�k�M�(<�ZEJNa��HfU����z]1'�?������u=��]�	e7,lR*%`߷��G�k�R�� ��}ʲ�mvW�kYY�;%�<"�;O��$�1!�3/�Q<�:�{̓�HA�������;v�#cg����)A�{�;�q"�9�hf���z�W�@a��k>� $e��φ���TNy$�Ƈ>��IVޱ-ࠗDn�$ͻ���<��7�[T��
l 5(�AW �X�׷�btc7EǘX+=�y���3�G��7��s�Iu]��9��N���	�F�<��:�[��jߗ�~xN�El��>�.��A�w�Х:?��f���=�,�t;{��~�}�p�o�i��X�"J���4k��L5�5b�
���e*�$c�\�r%��D���a�U��G�l1�O/�2��J�4@��P
��C{����(Ƽ�7	0��r:��NY���ҋ�xZ٥��>�b\�;����~+xW
��8���qno�V�yG��
G�"�o�3^&z.M%E ��ݤ����u{�n�.�'h6\Z�:L㳠2����܅�\ę�'h��+-�p��
��h��qQ器�L2����;���Ӗ�VL�=�g�0ܕ(�J��L-�0��#�|�b�܉��U*�)�|�;{7Y9��>&�<�M5�!bK�Cq��'�2��x �]���Nޞ~�`�������2�S��Û�l^}��B��]�%?;?��_�t�F�����؞���~8:���`+��"іl�:�ӏ�������	4�?1@�_e.]n8�����ǆ��շOE���D��?Y`£��w3!6�9y撂p4��qq�;&	~�_���ğ�D��vF8u�ܯɐ���꽨%�6��(��l�6���!�����ۤ�ű?�ɘ���҆�����r�Y����s_r�$�4�*y�N�i6�Ǹ�����7�6�D��xPC���I|ee�gu�N�1�d�,���1�.��;�5���#����|�I��(a���s�1�w�q��;�m`h����������������{ƀ�N.����$�G�ٗd'9�L�k&�"�+\8���C����'
8�O?u�����4vʎ�$Lؚ_M�� ���8p~>:e\
12a����G��$k�;Іo�~f���_������}[`D�˻����'���҄H޽C���g�}|��͂X��Q�	z��g��S<l/����I��-w�(�T2]u��uf<\j:�B?\�.��V�;{�'$�����ǤM�����bL�ǘ>v�6�#�{�}�����bQs5V�w[r����vDvY-���k0��&Uy�u��ls�jV'�O.�11Z��<�A��5l�.u���������!cY��?� �h|i}�c�	PK�(���/I��S�RY-�o�8/\T�����}�qa +Q�G��� �;/ �n>/p7��sRWPM�>F���]f��-v�-Uz�]�g���z��91��B���"�(܁S=[@<��0��{4p��l���x��@��:�=���u��U���>[��4�G=�Vup��i�l�l�nXs�]��SөUa�"�R2~,�r���1À�8���8��蠓õ88s�t{�ix0혛��cK�s��n�z�3���Ǹn��
‟>�	a�ݫs�������m�0�B�GL�<P�����#h�j�B���"&�q���0�/E��%.�L������/����Dn/��Z]#�!�6����/[�[���?��)\/V��m��ag���f��6�r��Kc T��xy2`�RmQ�|�z�/gJ��͏�"�����E{�k�nR��V��pUB Ƞ�F&�}�0�/=	�p��}	�v1 �o� �� �C�$�.�j>eӱ� �4��H�~& �n�#2�*�&��Wr�/���e��XvX^�Z&�-��|����?/���>}�������k:`������e���n����}�܌��b���6�����}R��q�bʟ��.��-�,c�:�lj^�+�<��Tuq�6x�,-	���	���n]�`�U�&?(%م+^M ���.��~�tC��$�o��pv[��M^ZN�X3���P�~�����ŋ���	��C�/V p5�Խ\���35���O[�`�VO��p�$�E`���l�����?�:�d��䦚��٦�.��^�n�S��)\:x� &����ד��k���Dt�ܵ1_c�������ŝ7I&j�;��Ö�G�ޞ4�g�ݹ��^v�X:װ�FxDZ�'�h���n	�kB� ��n	����%�h��0F�<��Ŝ�J�7��ת������(����H��:_���*o�����)��o�W�Bw>�d����f/i�OW1@2
R�'��ߝ��/�V��wT0�r�݋�]as�%(?�.+d��5�B.E\ɼ����k���$��e)���x��^G/�Җ�u�Ԅ$�>�=�.��1P�������ba�N#5���S,�Ub%g��4��ǧ��Hb��T?,�S������~���v<�
G@aB���Tz8�Zb��^5)J��}�F�|�}7��@x:�C��P�� p9��=/�T'����n�T�v@��3��\�6W'q�JB�,�v�x��!�M9H���߈�
lT(�ej�i�c�{Ҹ�
gm���հ�A�����䪋�:��DƏ$��Xƥ���!��;-'�nf���8��b|�=�����w�g�7o{�8g{�㎓~�݂��%F�����^�ќt�����&�}��n��jnN�4�g��d�y���ũɅ�M��R�T️,�� �]����F�Ǔ
����J�[wy�K�b�m����Ӷ>
�fsH����}�d��,�|�/M��၂������euj1����扅V�j��?�EI�9��Ñ��F���O��j�$��K2�b�5G#���lW�M���l��v�Wx�ʦ�z`_j���n*W$HD�FK������\)�a8�J�dÔ�\_�.o4cBKx���CE��Zz�	��mUn.�h/�V���(���/��*��y����zЌ�%�M�v]��^��	0�l�a���I&�Y۠�Y���;��3w��GY�An}�u�#&'CNЮ��~31��4;T���>�]�J7'�����D��6���8��Ts�98I��3P��������!eR��Z5gy�
�А5�B�0�ۦŊWmPLA�
�K��b���n�y�Ud�u6���ya�r*9)_,Ƨ�EА�1 �l��#��v�}zsu��]�c%���+w��Z}��m�V��pF�j0_$6���lV�L�4���!!8���N&�*��4:��m�x,�:�(0�<	�"�Gpz_���ڈA��
�@QØ~Q�'c� �c�CN��Us��N��\���?YN/�m!z
��[�;�d�
t.-��Gޅ%%[�8ds��hEc�ъ�����&V�rY��8]�]-�Q���G����E�D��bctj`s5/�|m�8����u�:+VL�D$4p�����F�M��[}*���4)� �w�L�x��y��=7Ǭ;Te�bZ,�7gз�ΕW�(O�Iď��P行M�N9}�r�	ђ�w?-/%��������K����Ŧ�,��L�ލ�o#��
�,8pdT'�O@f�K6ס��6�t�Tx\M���,X���K���g�}|5ᦡײ�R� ȞkEUz����	�TW�	إ��: WM��hM$�;�DestK��2����1Zލʺ��k�|6�{�o29���j��D��b]����BmrB��`E�uwl��zc�M��z����v�Y�Xg�2+�e֟�x�kg�Uy'I���`i���A�+Y��b�_ݴ�c7�B�۵��
���=j��`�e!�O��>嵝(�x1/�[�t�%�Lm�i�dj]�S�b|Q���� &�ң�e�<��Y���@��zRd�&yq�ugP�1���~f��k� 2��d���M1�%�Q��L_^k�d��@9���7J.��cR��z�X����ٓ�E��ߥT� I�;3D���?�"�N�z��C8`<��ƕ[-�� --
Q&0K��!��hR�xpT�iV�S����E���HG^��n�� X���& ���	�_�ý�7�.r��H�}�n=�å���GvPL���ZF�ԩ��z~Ws��|�'yV~�����7��O�dF���S�	ϽGw��x���:��xSu
?x�_5�
,�V�eM�4�V���|!NpR�ۉ+r�e�:[�F�e����,�km捸-P,����<��I=���AҬ��
v��g��b�M�]/���@�Ǳ�s,~{���:����!�I+�w λ�M��Q�5�OLo+'�6#y����,0p��g\mǺ~RA��^=;>�E����'�P�Ҏ~��b�6�Yȧ�N�憵|�OC�(�ɤ�E�H_��Ɵ�0��B�n�O*9�������C3^�6@�nW�r���Q�������79՟� �?�q��8����Y!�5̑�xu�����;�Tj|�
���i������q�"�FnP�,A���hgn�p����E��|�O澂'�2yWS`�z9�T����~��19��ܚ�S�H�m�$�	�S[/�z �	\��O�l��!��� C��D�����,�یљ/��������6*�@�i�b q"�W8~7�$�zcA��Xz�֞�eU�M!C������s{�:&{6Ԉ�^�)��q��t��Yc��	m��ԼmUGW�$q��Κ�'�	W�r�P��pgQ	��MJl1`��E�	|��G@�6H0�&o\��n�E���ū��N˴2�"�2��Us��U��?�e�� ��8(�K^Q�l�9�S,0�
�g����Fn�w�<�CT�T$7;"�����#=5�is
� JA�g��+����C�Ȥ�,�W9�)��C��Z[*T~?���I�
ܷ��ƞA��R�=ln~bt�����n�I676-Q�:9A��\2�a(�9�Q��z��N���ֳ�\N���&?�ct��A��gQ88���=1-�< �>�����_�͓ۊe���(����5ڇk;Bv��m^�+H����9ʏ�]KT74�7v�
�V[�5Gh�_� �2n�?ju�z[.��:���b�<�Pc-#�]ُ_}^o�e�uw9���,�2���sC��K�5���10�Yg{٤"c,��k����z����(�г���cC��K
}�A�j���#M<Әq���'�,Aԯۄ W�j�
*���N4xb/}[�'�M�ⲑ�C�tW�xv<*��K0g@w�]�~�̨q���ﴵ��8��3V����q;$�Ʌh��pيw(���T���9d����.e��8�OE_x���O`����BVY���\��DN�p��~����ĺ·$fg��M����u��T�M֧��3�//?�����)�������DU�^�g�ou�-��a��!5X�?�?>ڿ0έ�J讳����~�O����7w��$L�eUx�,餸8!R��G�~�m��c�Ll`�3�U��CF7�q���7��4jL�1�b�d�|v=;SEZ�Zzy?S:�j�Jubs_���
 ��꜊`C�PMى��j���R��k�����fQ��OsD�
4��5knZY�E%�n���{[Y-��(��lpc���T�'�p0:�px28|kh$C/-ʡ($�T�#���� ?��,tM���~nk�&��L����~F\�j�C)cb��!�g�)�6�&�P��Dxq����)_��x�2��c�EPj�vp��/�
����ʸ`}6�dd'���Q���t�f��F�#`%�s6Yr��k�\������99�H�5B�n����p�F�����9�=�͗!�G�O���`)�h���-xԉ��>�4	�`­�Us3�-�um�r��3��	���Xy���W�성rrdՄ*0�cf��0�>=+��Ɔ�kg�֟j���a�3!C��C�xA^���� .e{�oQ4a&c�MZ� տ`BjGpr���v��
n�H�X��-�@����
�����O?Z�)���,�i��	vTV���&����b,~]�O?�>�?퟼=>�K�yqp~xx2|��ݻC�DOޝ&����Sn���r L��	8y�i���D��lH �`�gv���s����Anͺ�F�F�{���?����O����of���[� x�]rt28d�1�k�7���J(1z>tP2�8JF�@�(!Q
9j41G�j#b����m�IU�=[�v�F �4���xku��]yz�2�M����^���:i�6��Ci�f�l\�U�~p�����mu���Cd��*S��^ج�5
��Ж���0�`���~�6;�u��J�gE�O��������:{H��ΨpRyz� v.�?��g��
���'��K��n��{��d��4�Y,f�/���RU�%���\l�*P����n�I��%�tz��x1[N&/^��q�8�����n���£���������@D�O�Z@!E?ʏ-������Z@!�;ʿ��B
o�?����.��k�@��B�?�LqH��z�!eY�~l
\�X�t3�����a��sn�^�+[��^@&�<���+dhtO� {,��<e
���ԏm����"�ɚ�����Ҭ"�w����b[=ս?<9<� =+g��ٓ��BoA�E<��K�c{e���m�+a�
���'7P��4�re��yj
e�DX�C�h�VS�f~��;�+��|j4pSԮQqB=#�,�n#l>�~������#�)��w�F�w�"$�I�#����hx#�-
�6��S�R
h�BQ�o@��(��߲���=ݰF�T��6�ay�{.�!�7���^����u:k����0AP1���h�D�,���\ME^'3HN.��u�ٕ�Nf������ĳ�v�g-ٝ~���롏��W�%���?�q��C�G�U[��)Yc���RN+�Xđ�iv���	\Y�o<<Z�<��3Q��\�ZL��E}γV�ے��£@^������Yf��K^�q:��Ug�r9�����lgq��yu-0�4]����LM�@n��B</���a��x�_0 t
ş�	���aͶ5��0~HA���V6��d;lZ�9dv�� u��Ϙ�/Ҕ�i��,�
���j6��1��C�4S�V��a<YQ���rt�ܴ|P+�~
��x�F�u�=b�r�j�v�i��}��
O8����lt�>�G�Ȃg�����(��3O���*}20����}�hu�U��L�B�]�k��9i�k�����9�X;��/�g�ǔ#�:��qm��P6����h4%�)y���bJ<bX}�LBI��'�:����?����n��6�UBSe��t7��5�E�@�?�B{�(���KAd���y�&���%�	`��{瘒��&�0G&$7w�Jw=�Be.G�5f���So�ڙ��(�<�zP1/5��S�a�|sْ>�k�S���Xc�acV�	��z	��h05�@zo����
����ҡ��ˠz�#%��j
v&�y�`W�$&���F��6��iQ�<]^���
C}���F�f�������*[|�oq7��Z�ʪep�>ɱ<��m��Uk��.�{�n��T������κ2����밀;{����A�p�p�
n����Ã{���xD�Ɔ'pr�5鈨e���u���h^�>K�@��z�PS���v[��A
�S�����|X�m�l�x�����!�><��#��6~�0{=�=zY��5����7�i��j.���S�([՛'��e>�tO�ſ��yV�n|��y�,&cҲ�ш��8,����%@i�Skf%�nj�nUѸ��t�Z��`�9���R�*�7ȱ�QQ,�ɚ��v7����jNI��1/}S�i�;�˜�O��d���%/7|�ٗ__&�\�����o(\�T������Gw6M�tBw�nf]�&��UJ6��#r�&�q~'Ɋ�H�5�J�{�I���/��Ip)QS��ϐ�'
��&��/�{�!@�
҉/��aiϗ�0������6�9�n�?Ͷת �Q3�~(V<���"��	�6�Bp�~ԐH��=Ol +��ј�#v=/m� u����fY�8=���*l\r�$�Q�@{(N�6 U��/��Ϋ�S$����ӡ����I5�.���L��֧��*P	1"%GS�' ��J��F�b2ߕa:�?����x���G��G�t�
g�7�:�X�YQ�+��\�&��ܓ���{�r�����p�9�I�A�V��@�=�좚p���>��M@>*�&��~�bCs�yV�p����a�=��h��^�d��7��V�o��J���3�Ɉ��NFA$�Ŕ�`1�¾j����b�#�9`�p���Z�:�u���.���!����j�$1�*��bXV�aŮ$.�F�9*y�I�F�|A�c�g�Z//A��+v�W�Y�;��H�&�Q��|� �Ŝ�E�� x��`ɏFP[�ߴh9�]8]�d9a�ٛ9�l� �[Aύ�s\u��I�Z��$s�z~�����^<7��씊ҙ���8;��T_7:C�׼��������4v�e��l��g ^�z�Oۉ|�;I��2�X�HX7�M�pX7��<�HVa�DY0w-e��+�C[�d����ف��ƌ"_9k+LU��~�u�m��ٿ1�!�VM��3%+Q�~ߦ��$� Ǝl�֐�RaG��k>�Z������<�B1 ���/7�C�g�Y�֤
����_L�Hq��A�<Aѣ�,�3�����˭�8�~ʯM�jih$q�_3�I'�||z%+�ʞ�?������<���x0�dL���t�H�f2%�Ξj�G�j�<�*����������{v��8ڴ"���O7U_CV�Ũ�VCP-{v˾y��.=���1$:9�yN�,�UB��T�H�E6y��x�=���%G�ԁO�6�Aiz�&���6��fs����6�������Pb�\��,���Mw����omkI>_�B���@��f	�\򂳙9I?AY�Xr��2��������1�dO<�[ꮮ�����w{��n�.Y����M-k�j��%���~����д�Yߍ�@�\����8t�&�hQ�E(�&�+�3�f��"�]�ɻ1���+Z�J5C�C�dÞ����f���^� `�k���d������m��WI�,�hv���E�H�b'D��q+$�p��v.�a�����B8]r���([�a.�Ϩ��}<��,�O�ұ������1�Y�p��R��j�E@�!?'��5� �9&��<ӟ^��?H��AB|��W���b�k͈p!���{�G5�
o�`8�y��\Ed�CF� ���kol�~C��&��ǜ~��jc�
�l eYI�}���V�g�yLw���)Ĝm�#;��<���h�9�m��JqNc���$Z'�����4�(N�l���"gu�m��$�Վ�a�$?*_#O(�[G^�{g������̜E i���q��J�#�J )��s���eEY�GTN׷��1/��:����3���t��#���I�AƊ��p�'_EP�t�a&5 !�CM�B ^���?��d�B� �9<gp��9n�m��ʖ�4���P^�H�l9���r���2O�
�?lGJqd�+��p�r^��O���
� _E`.'��4��4��$ZN�[(����0Rw@��
+s������<N��/�)I
��%��P�O5\J-`F-א9GVl��>!��˯ �wo+����$P���������/�����nmmM2 H9�қM�R�q{0�ӗ���6u齓�N3[��a���)̱8%u�\b�N��*8m�0��&��.��N�t�m�c�-�w�3���FI(�6pYh�VQ�!$H�G���/���1�}�?z����r��e�DE��W^~���]�A�\�n8��:}r2� .4�a���j�����䁽�0�j/!8p�>���)jN'g�/ě�bJ��Ǉ'�_�������$=k�rTn�C�<��K�[��0��xqw=
����}B	/�@ґÏfc�3��gٻ��4%��r�`��D	�a�qfd��%^/���(5ӣ>�K@����,@VNW�Vqgf.<k!t�U��~K	m`̴d����@���`
rP�x73k�����x2VRt $��S�m>Є6�c�"Z&V�
\C�~�4�T���X�4��M2p0)[�a��(��[Y6i�]&��V�a+��u�fC
g 3+ i��Vk'��b����N>�����>��SP�����+�1���Z�Vn"&*�b*V�-����

0G�]�T�>k�]~K����
#K���Bd��*��
�TL�`çs�Wj�K�9=��<%{E��TbD.�Ї�lfk
_�x�0�eo���I>�ܷ
���>�;
����_fg|���j@�з�?9u�φ��+yǜI��ɦ3�"oHAV ���!�N_uj�]��^�y�Q�7нC0�44����Id���C5�	�"������6��!7�dǊ���Dy�N
�k_�+P@j��=l^t��mҡ���kX�o�o^�V9\Q��fԸ�92?0�� 9}o�BVU����SH�S�~�
穯�3���
�M���<�v��
h,�����8�>��]��%Z�ƙ5#ե BC��9���jbu	dL���@����mՎ9:�z��j����#N�˾^ҟ����m�Qr�y�st�9��??<��Z�ʽ�]v��3�N����HH�p�=|�K���PE�35��0�Xt�Măc3l	�>�	Cd��
�	��Aqߦ��$�9^�T:�^��M��0��ՂD!��De<8�<,ǰu�� Q��;�8 ��%/�bvA��z�۲�{Ӄxʋ�	P��\��XJ|Tu�.��g��%#�Y1�J�1eF�G�d��I_�v3H��~ٯG�?O�̸FX�!{ {�n?l�[�X�܏�d��'u��`�����Tgq#��
lR�!ם�
'�I:�Y�;5,H4f��sk�l�1�r����:
tj���D~r���K+z*����2�q?��G�Œl�'�)'?�{�0Ո�ap?R����J���~,4f�I��p�{
��ok�!�Q��iS��D���=���mQ[Lg�����E�F�錶�k��vȰ���%5�?d�s�s���N�
WLA^5�tB�
䤘�A���k��$O�f�K��ة���$��K�K�ԩ���K���G�KŴ��Q�K%��I=ٹN���ͿD�h���d�N�l�=�J#C_�nmk�}�}>��즘�L�\�Fd��Bd��Ds<`͙K�Jr�r�{F��RX�ED��;�1ڨTмv0�k@�l�_��:)w�|稓,�K�<X?�.U�:�����Fb�J��Ŀ`�U Nޡ���0��.��+�Ĵ����No;	>o���5%�L�j;P��6�Qz��oLX�_4�*�hq�g��V�Z�
���0�ܓۗN���U
ڝ��k
�T�����@E��ޒ�(Rz@�Yz�`p
�l0�p�Q��g�s�Nfn���+��$O4d3 6E&&]{��YB-߼�B��fZ�ܩ��1���fa�N�3��4v��o��}L��hn'Ĵqp��B�� ���h	p���S�!"I��B���8R��`�~z@q��{3��gqȆ3�*�av�݀Ee��ʚ�%� �D���'�3��U���T��ª`�?���,������򢐫5�Ġ�4e
lb���F����c�f�{N���=;�w~�om��y������_%$XE�s�	�;=-�9�� D��3�2R�#�S�1�G4���A�q� -I��c�x�����Oͦ�~��n�6��]Q2
Պ+If��27c� l�s,Z��΃F��ew�]�!�i䬞}��S����c�}�LԐ;���Ut��e�oɺJ1Ț
�I���|�(�<��R�X-hNy�n�cG�
���LfU���kֺ�ׅ�;�*������8��K�eG`�j_!�+�!��v�ʅCU�ζ_删P'���W/�M�{�~ŋR)3�9�����n��P�7�N_��Xݨ�^<�حTb��@H�b(��0�h �Vĩ���c%���V��p*���d�D�jh��S�,lYx�/�9�bH�5�/�M1
�ZJ���خ�m���س
d��n��K���R�47��uWɶ=�-
ߓ#�4�I��V�����E:>��O���#��Xr�%�Z�U�<���/�	S�wPj}�x�0dJg9f��ЙQW��:(�n(�p0�,�T��SI�l:i�;��m��|M��n.(�@�"ZS����:Z=7�7��G~��KW��T��O�s�܇�z�����h��JA�顟ҹ(�4�n<��Õ&�����2��l�4�PP�Ѵ(�w���6��9r���d!�o�DP� �Ƞ��
��4�,4�n�� B!�*=W�`<-��F��� ,�I4�
��]���I4Ĉbt3����Bcj<�
�t6�u0Z!��-��)�����a����,
x�V��NG\�E��#)_�8�-�oe�/��@��]Z�㻱29ě*�g����W�@A8�)�����ZF6��&
�tn�BUSC���Q�=7��U� ���\)S���ϛ5�/bEL�� ��M8*�P�
�a[&��ˡ�PN^|��+���nHRe:�?��.����,
��NG��=��H���Xn'����NO�O�����z/ {���;��sj�#���1���t�������Y+�5� �6X7색�D��r���(^�F�Y�^��C�q
\�tKh��&�kt�g��U��)PV�0��휝W	k̕K����ȿ�<�4�&ڞт�ȁ��6w?T�|4��t-�3 OR+�q&*�WIC�Fg�M�|��F�X�QUH�� ?�Rdz�N�b���V;���cb�%�U���t�}��ҀL�(cnWb��0���W
I���x����}X�N�ԇ�m�̺s8¬	0_g��AN��1�KJ�� ��?u0<�s����t9��1,��'�ɾ4K�x�G�ݼ��b��W5���y9\F0i����aj��a��е�
�M���- ���ˇ&�I�W�L8���P�b�@"�ʇ��Y��\�a���!D�:��
'��LP5����b�r��ݎ>�=�X}��Xq�/�����h��L�S���(?�`��r�7gA���6��'�N�o!貁P��X��WbQ��.�*�n�!x,���������aOK����%�Kt����E��$��^L��{t��e�G�
�(-��]4;��A(��z�
*=�*y�P����r�j�.�U�i�Vή��y���o�v0����I�p�о����b-i������	��-����&�2�����Y�{�\7
�c&.=NM!|\�
����ሉ�#a\L��w�l�E�Pp�2X�BͿ��gx�\b�=%�߼2�pc�pd�GOQ�Wvz01��tåϐǨQ(�P�320�<�nhfY��i%n���c��h�~�P�e�9Q<���.���N6]�^;,��p˓���v[9K",w��ZwXIR�1�?��
��l!.��;oG
e�yzYA���d1b�Ylɒ:+�����"r3���V���L��_H�ee۰��q�Y �A\(�H����m�[��^��?Y*1�iw��R�xl��(V�����h}gB�'����]�����E/v�<�
�<��Go�f�7�]�`���ۮ!1?�Q�ݿUwqSY�H�z!?8�)(�Q�jm�k�R������_���F�2HaF�KS�h 
)�L�*�ϖP��ވpl�����Iۖk%u��Or���j�(~&�W�y��M#��ZWKņ��'�g`U�9;9<y~�!��h(�>���_���
�V6)��,�jnuQ` ���	 k"���|l��ܯ��|ϟ@����F(P����b��2��Bk���K�'�u�\) �	���r|����s�M�]y�,��W��U؂1��b̒�d%;1`mIk���;
B��ݦ �O
���𻓰4����d�ļ�K��<�|�_��	�y>��j|c�\|xz��Fl��
85�)�";��1!tG�����l ���,d�h��H�4�fC�l�^�Ȁ���n ���`A�<�QH�v^���ѱ��1��u�I_�@{��!	LQaKR���0���a,v?48��.�T�"I���#�Q�6���˅j�Sj�f3���H�,p���y¯�Ay�Y͇@���G;�-��t�ͳkrTK�Y��*��婏F��k ���qK+�i����%H��
��+Y׶:��{�Fz�����݌K��-#ҁ�z�>x�v�fZ�A)C��4D�Tsg��W�e�a2W���n�^H�o�o��Sup�G��`�	?����ߵ�k��T�)����R��w�
�U"�}��r������"%���s���)	�m�l��_5n��� �G#'�V!�O��r�JZ�>�pDgB<(R��xP�Yz��(�,�ǂ+O�un#����V�@+2��zǸ���%׌E9u��G�E"�h/���/�
K�=�-_E�P/A�
|^&Ќ�p�W�mݦ�b�E��C�=�*D�p	@�)�Ҭ,0�o�(H+ǁ����Þ5��|�~��.�F(LNk�IÐ'������4��
�5��4��0�����m�l�A���J2���;a7�W��G9ɻ��Ʒ�$�kk[[27��}��w
��Ws܉�t��9���Ӆ���>���i}sk}����O������.쩅�k��1e�&?�ɍ_����j:��ܶ�jt[�k
KR�
,UAI���΀�K؝�:�w��)�%��O�Q�ϖU�b��x�Tnm'w���ۑ5����D�4n�
L0��Ӊ & .Դ�N�MI�n��R�blc5!;�1��}L������`���VF�ك�	�ߓ�T>���[`#Be��
�ۋ��e�1���,�rQ�QH�h�eĭbu�)��y��t@��Ȫ^Y'c�-M4[[3:>��vܞ����E]c���f�#e9(�*J�� ?�g�	�&#H��4��Ԝ6�. �$����DȠ@]<�~5ϢRv�BJT;�f��])L���N_u�+�94b�5[�34�O�!�2d�-2���&������N��%�
���>wH���DW@a]�Iʈ���߆ӣ޳=��`�k��ѫ/���J�g��q�V£(�+���>�@_��פ	���a�:�jl�b�%r~��D3 3�)�+5�Vcf�����n5H5���|r���x=��fD��mv|�r7m����+e�_1������+�|���5���_V�wQ���
�<B�ĜČA"C����|�C2���~s�&�g'1&j�z�g���Lm���R��U3��46(������
�p)�F��+��&{W��SL_��o�*Q��9C̽�/,A�(l?X��%�ٕ��0�s��&����ByE�@�)�aX;��d~��rk���eG�`lX3����,o,�#3�<�$��
^w�LW=ñ]�1��Ҙ�{�� �Y�c:��D���eE�,� H�)L�q�D�-I��|�,�hU�w���@"|֕�������뿄��|��=������\�1hX�E���K��+nN{�ym��6���"���x�F;��F%+Z
�&caH0K����<X�Cr����eCyD�����*,rЂ��LNlCp���Rv�Z��j����ʽ� �Pe�G�=�vE�;$<���|��n�����I�2J�̃Lr#��.c/�qJ��M]�E������3��R�v���N�w�fAE�3�sȬ�Y�KWrδf�32/Y
�^�� ���G��,�_�m�o�H�T�+��=�|*_��󢳈�C.�M�l�U����d�&�����C��MOk�����KŔ0B� �[y��]��`wR�V��1��|oF#�=�ͅ�c�PԭD�H�K�I�h!���dr-��?���8Y`M8����14A�s���P��,/[��->�������N2�?K �/ȁ���X{��ř�u,:��m�����AS!oG�~k3� K��y\�
c��k}Q�4s�ƪ�a���0w�������IZ� ����]��P.1�����6�4�OH�����գ�e�+�vA��dV�d+�ۈ����
��4:5K*�n����6�.��H�i�	92�X�NC/�Ƿ6��R���p�\����	��P��#���C�+f��;�[��`�M���K������������!��m��ϰ��L45����T��ݜb�U���A�7X�1x:��]��}�9?��+�z�ؐ#Nt.L8i �leTx���Ȼ�MHl� [����M>�"E |�"�~ܠs�A��hg��14~�Λb�.�(��Gv.��2�=���`��S{:�a �����3��B!ٝF�x� ;�%�2ԅm����F��~���G�"I�� ΰXc�^����ϝ��X�ql�	��+�g�����ؕ�&L���n��۸�(���̢���e��oL>�Yx�|�=ʂDoA�����"\}�|�"^My2�䋰��Yku��l\]] �Y�*
l,�@�.��	D�[�BMt���ݟl��,���"^�i1�QOg�x�V�ԣ*�	��y�=
�;m�>��S�b�rphn�*�a_��#T2�H��gP
m�
��]�n5�B:�^��<�%W}ܨ���̚�h�o؀��Y�ڱ�0|�� <h�dɐ����O1CF�hϴ!�^7W���X�!��U�wyvE�/(q�^�݈�ik���E7������/1$���߆-�baKgJ+qh��#��k�DP����yf���t���p�}�&ܜ�����+�E0��:�*>1���.07�kX��q�)� ��M2�oW|��2���L�g��2�j��s�5G����'�\)�S�Y@_��#��+�u��:�u��o9{�)��[,���@�@ �raF����lW���-V�*:��D�ɤ����F���D>E�D`��cfV4hU��ge����p"���;��	eU[�.3�Z6]�!��X��M�������dTW�Xw"�(���Fz7��c��(��J�O�[�w��D;.��1B�3E6jg��m0H�ej5���ΒҀN����?��r�����T�+����Q.f�$�u?3Ǟ������,��ý�g�5��*���2��i-f��3YLڴ��"G��c������4hʿS~�7��A�7@
����;�f����j�U�h`Eߗ\�)�S�?E�Z9G�����l���Y �mWh	w���a��ۤT���^�%vRI��wsM��i�|[��Yf�Ah���ԔZQ�)̋��'�x}ݨ��AL��n�Y2������u��T�-��}�4e����y���k8;K�	4�"U��]mv����9e
W�{�D�h� ��X6�ũ�X�`���k��mۭ3�5N���c�h�o��r�?iԕ�d�Q<�=�Չy�ugn��qULTt�M�#5^I��5LӘAQ�A-/��F�"A�b�@)lΎ<��t���P�;3��i��.8�Bo����	LQOC%�v�{DI �jg���NX��`�'bj�Tx��v�a@
D_��qc��^|�,��KU�WN�yTSg�`�4��m����?��l.Y#�,c���ٜfiF�ҐΦQ�����e�v��{p>O0��pj,�U�N ��ėi��4�4i����2�P���Zr	X4�m��*�7qz���;��F,�6B|,d�i[���6�N#ݬ�u��)@�r�����`2�%���?�v���)l������?Kz����|B^���bD^!��/���q�K��6�t_�P��U��Ss���)��.;WN�$n�t(���jt��$}��q�����08�l���Y��]�-�J�q�ؐ��
��W�ؾ�$���hs`��o�W�oN�On�~���C��X�AQϯ<����o�+�|Emθ]����/���=^n����k�.�?+������/f��B���}�l6�F�H����q�w���@:ߺ�$�)"=
rr(ÿ^����$?���gR��ы�m4�):����RV*Tɴ^="�%!P���qq%�����C��%\V_xp��K�G��"�3���Ӝǅ�y�tI
��e2��3/$%l$���r�<�+�?�r�XV���ug�\k}�eC[��I<�s��Wy�?�/���Ÿ��?Lޠ�\�k���;+*-�XT�ədE���>q��/?�Ro�6�o��_ơ���+/"e�'���ʈ�,�����,���c��~D�!���Bz`*��S $��
��p8�×`?�Hi�ܽ�?h����@ߙ~�
��˼l��T�,S蒖�W���-ȟ�U�x�����.������T�M���p6�
/s	��Y9�a����C|F�}�Ğч�\�����@.��n����y����H���^t��/}3�z�c����0�.�8��$�dj��hb�/�;�'&�Ana��I=�l�}P<����t^���/H0�hN���K����"
����mt��h��xd�N4����a�y��Am�U����;8��7��|�P�u�i�Z�Y�`U�����Sg�f4r~���7)
��rL�X~�Q��
�	/
�z�E��a�����ŀI-T��1ꜜ��Y0��纺�o�e���C.��p��;����:o��j�}�����
�D�);̀:�ԩP�:F�R�z��xRF�
&��O*�>B %1x��O������i�,X� K�Ԉfa8I�̇򷢿w@�on�?O�ɟ�51*G'x'��D���a�*�M�ǖWg�҉��|�����DV�U�ޭ�F2Y�x�=��ռ��iaUM^@�?�ʹ@�J�I����6X��HXo�h6��-7�������g�#�- �3��`�@������-�-�3%�e��[E�-�'e�&��oLH?�H�_�q�|�5�L��iK]��|���u���,.���^�E����r��wm�=MI��ǈ�yQHh�wS߹���X���L"	�h��:MA9�a
e�����M�"��B�F�5��y��?����ٯ���W������ȟڠ�IǱ>�f.�A�M�)?ˡc�r!�3o