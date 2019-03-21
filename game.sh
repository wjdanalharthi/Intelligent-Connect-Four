

boardDimensions=$1
playersTypes=$2
lookaheads=$3

if [ -z $boardDimensions ] | [ -z $playersTypes ]
then
	echo "WARNING: you have not set the Board Dimensions or Players Types. The default will be used"
fi

if [[ ${playersTypes:0:1} == 'm' ]] || [[ ${playersTypes:0:1} == 'r' ]] ||
	[[ ${playersTypes:1:1} == 'm' ]] || [[ ${playersTypes:1:1} == 'r' ]]
then
	if [ -z $lookaheads ]
	then
		echo "WARNING: you have not set Lookaheads for your Minimax players. The defaults will be used"
	fi
fi

julia connectfour.jl $boardDimensions $playersTypes $lookaheads

