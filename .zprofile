# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zprofile.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.pre.zsh"
eval "$(/opt/homebrew/bin/brew shellenv)"



#for java
if [ -f ~/.use-java-version ]; then
        export JAVA_HOME=$(cat ~/.use-java-version)
else
        # default java version
        /usr/libexec/java_home -v 17 | tee ~/.use-java-version
        export JAVA_HOME=$(cat ~/.use-java-version)
fi
export PATH=$JAVA_HOME/bin:$PATH

function lsjava () {
        # インストール済みのjavaを出力
        echo -e "\033[0;33mInstalled java version:\033[0;39m"
        /usr/libexec/java_home -V
        # 現在利用中のjavaを出力
        echo -e "\n\033[0;33mCurrent specificed java version:\033[0;39m"
        java -version
}

function chjava () {
        # パラメータが指定されてなかったら
        if [ -z "$1" ]; then
                echo -e "Please specific java version. \nex)\n\$ chjava 1.8"
                return 1
        fi
        /usr/libexec/java_home -v $1
        local checkJavaVersion=$?
        # 指定したjavaバージョンがインストールされてなかったら
        if [ $checkJavaVersion -ne 0 ]; then
                echo "Please specific installed java version."
                echo Java $1 is not installed.
                return 2
        fi
        echo Use java $1.
        /usr/libexec/java_home -v $1 | tee ~/.use-java-version
        # ~/.use-java-versionに利用するjavaのpath出力されたので、上の方のif [ -f ~/.use-java-version ]のところで、PATHに追加されるようになる
        source ~/.zprofile

        # PATHを表示
        echo PATH=$PATH

        # 利用中のjava versionを表示
        java -version
        
        return 0
}

# for git
function rmbranch () {
	if [ -z "$1" ] ; then
        	echo -e "Please specific branch name on regrex. \nex)\n\$ rmbranch feature/#1.+"
		return 1
        fi

        rmTargets=`git branch | egrep "$1"`
        if [ -z "$rmTargets" ] ; then
		echo "削除対象ブランチがないため処理を終了します."
		return 0
        fi

	echo "削除対象ブランチ"
	echo $rmTargets
	echo "----------------------------"
        echo "ブランチ削除を実行しますか?"
        echo "  実行する場合は y、実行をキャンセルする場合は n と入力して下さい."
        read input
        if [ -z $input ] ; then

    		echo "  y または n を入力して下さい."
    		rmbranch

	elif [ $input = 'yes' ] || [ $input = 'YES' ] || [ $input = 'y' ] ; then

    		echo "  削除を実行します."
		git branch | egrep "$1" | xargs git branch -D

  	elif [ $input = 'no' ] || [ $input = 'NO' ] || [ $input = 'n' ] ; then

    		echo "  処理をキャンセルしました."
    		return 1

  	else

    		echo "  y または n を入力して下さい."
   		rmbranch

  	fi

	return 0
}

function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }


# コマンドの打ち間違いを指摘してくれる
setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [Yes/No/Abort/Edit] => "



function issuecommit() {
        if [ -z "$1" ] ; then
                echo "commit commentを入力してください。"
                return 1
        fi

	branchName=`git branch | grep \*`
	branchName=${branchName#*/#}
	issueNumber=`echo $branchName | sed -e "s/[_-].*//g"`

	# 数字判定
	expr $issueNumber + 1 > /dev/null 2>&1
	retNumber=$?
	if [ $retNumber -lt 2 ] ; then
	        echo "issue番号：$issueNumber"
                repositoryPath=`git config --get remote.origin.url | sed -E "s/git@github\.com:(.*)\.git/\1/g"`
                commitCommand="git commit -m \"${repositoryPath}#${issueNumber} $1\""
	else
		echo "ブランチにissue番号がないので普通にコミットします"
                commitCommand="git commit -m \"$1\""
	fi

        echo -e "実行コマンド：\n"
	echo $commitCommand
        echo -e "\n  実行する場合は y、実行をキャンセルする場合は n と入力して下さい."
        read input
        if [ -z $input ] ; then

    		echo "  y または n を入力して下さい."

	elif [ $input = 'yes' ] || [ $input = 'YES' ] || [ $input = 'y' ] ; then

    		echo "  コミットを実行します."
                eval ${commitCommand}

  	elif [ $input = 'no' ] || [ $input = 'NO' ] || [ $input = 'n' ] ; then

    		echo "  処理をキャンセルしました."
    		return 1

  	else

    		echo "  y または n を入力して下さい."

  	fi


	return 0
}

source ~/.zshrc

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zprofile.post.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.post.zsh"
