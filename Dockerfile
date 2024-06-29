# ベースとなるOSに「ubuntu」を指定。
FROM ubuntu:latest
# apt-get：ubuntuで使用するパッケージ管理コマンド。
# apt-get update：新しいパッケージリストを取得。
# apt-get install <package>：<package>をインストール。「-y」オプションで質問に対して「yes」と回答するように設定できる。
# sudo：root以外のユーザーがroot権限でコマンドを実行できるパッケージ。
# wget：Webサーバーからファイルをダウンロードするパッケージ。
# vim：エディタ。
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    vim \
    curl \
    gawk \
    make \
    gcc
WORKDIR /opt
# Anacondaのインストーラーをダウンロードしてインストールする。インストール後、インストーラーは削除する。
# インストーラーのオプションは「sh -x <installer>」で確認できる。
# 「-b」オプション：バッチモードでインストール。
# 「-p」オプション：インストール先を指定。
RUN wget https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh && \
    sh Anaconda3-2023.03-1-Linux-x86_64.sh -b -p /opt/anaconda3 && \
    rm -f /opt/Anaconda3-2023.03-1-Linux-x86_64.sh
# パスを通す。
ENV PATH /opt/anaconda3/bin:$PATH
RUN pip install --upgrade pip
RUN pip install pandas_datareader
RUN pip install mplfinance
RUN pip install yfinance
RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
  tar -xvzf ta-lib-0.4.0-src.tar.gz && \
  cd ta-lib/ && \
  ./configure --prefix=/usr && \
  make && \
  sudo make install && \
  cd .. && \
  pip install TA-Lib && \
  rm -R ta-lib ta-lib-0.4.0-src.tar.gz

WORKDIR /
# 「jupyter lab」コマンドでJupyter Labを実行。
# --ip=0.0.0.0：localhostで実行。
# --allow-root：rootでの実行を許可。Jupyter Labはデフォルトでrootでのアクセスを禁止している。
# --LabApp.token=''：Jupyter Lab起動時に入力が必要となるトークンを何も指定しない（空文字とする）。
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]