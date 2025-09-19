<!--
    SPDX-FileCopyrightText: NONE

    SPDX-License-Identifier: Unlicense
-->
[en](README.md)|ru

# wadb.sh

Репозиторий содержит скрипты для termux, которые автоматически запускают `adbd` через отладку по wifi и выполняют команды в фоновом режиме.

## Функционал

- Работает полностью в фоновом режиме
- Не потребляет батарею (так как использует job scheduler)
- Уведомляет пользователя, когда требуется подтверждение для включения отладки по wifi
- Настраивается через файл конфига

## Зависимости

- [WAdbSwitch](https://codeberg.org/kulakov444/WAdbSwitch)
- [Termux:API](https://wiki.termux.dev/wiki/Termux:API)
- [Termux:Boot](https://wiki.termux.dev/wiki/Termux:Boot)
- android-tools
- termux-api
- nmap
- make

## Установка

<ol start="0">
    <li>
        <p>Установить зависимости</p>
        <ol start=0>
           <li>Установить <code>WAdbSwitch</code>, <code>Termux:API</code>, <code>Termux:Boot</code></li>
            <li>
                <p>Установить termux пакеты</p>
                <pre><code class="language-shell">pkg install -y android-tools termux-api nmap make</code></pre>
            </li>
        </ol>
    </li>
    <li>
        <p>Подключить adb в termux с кодом, подставьте порт и код</p>
        <pre><code class="language-shell">adb pair localhost:$PORT $CODE</code></pre>
    </li>
    <li>
        <p>Скачать тарбол</p>
        <p>
            <a href="https://codeberg.org/kulakov444/wadb.sh/releases"><img src="badges/get-it-on-codeberg.png" alt="Get it on Codeberg" height="96"></a>
            <a href="https://github.com/kulakov444/wadb.sh/releases"><img src="badges/get-it-on-github.png" alt="Get it on GitHub" height="96"></a>
        </p>
    </li>
    <li>
        <p>Распаковать тарбол</p>
        <pre><code class="language-shell">tar xvf wadb.sh-*.*.*.tar.*
cd wadb.sh-*.*.*/</code></pre>
    </li>
    <li>
        <p>Выдать разрешения</p>
        <pre><code class="language-shell">make connect setup-permissions</code></pre>
        <p>Дождитесь выполнения команды</p>
    </li>
    <li><a href="#configuration">Настроить</a></li>
    <li>
        <p>Установить</p>
        <pre><code class="language-shell">make install</code></pre>
        <p>Шаг можно обратить <code class="language-shell">make uninstall</code></p>
    </li>
</ol>

<h2 id="configuration">Настройка</h2>

Скрипт использует `$PREFIX/etc/wadb.sh` как файл конфига.

- `FLAG` Значение сгенерированное `WAdbSwitch`
- `CMD` Команда выполняемая `adb shell`
- `NOTIFY` нужно ли уведомлять пользователя, когда требуется разрешение для включения беспроводной отладки
- `ALLOWED_NETWORKS` Ограничивает скрипт списком сетей (bssid). Разрешены любые сети, если пусто
- `DISCONNECT` нужно ли отключать adb от устройства и выключать беспроводную отладку

Пример конфига:

```shell
FLAG='AAAAAAAAAAAAAAAAAAAAAA=='
CMD='sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh'
NOTIFY=1
ALLOWED_NETWORKS='01:00:00:00:00:00 02:00:00:00:00:00'
DISCONNECT=1
```
