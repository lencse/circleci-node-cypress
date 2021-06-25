FROM cimg/node


# Dependencies for Cypress
# https://docs.cypress.io/guides/continuous-integration/introduction#Machine-requirements

RUN sudo apt-get update
RUN sudo apt-get install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb


# Install headless Chrome
# https://gist.github.com/LoganGray/8aa2de1a079222d9e2ba39ecd207684e

RUN sudo apt-get install -y wget
RUN sudo apt-get install -y libnspr4 xdg-utils unzip
RUN sudo apt-get install -y libappindicator1 fonts-liberation
RUN sudo apt-get install -y libappindicator3-1 libatk-bridge2.0-0 libatspi2.0-0 libgbm1
RUN sudo apt-get install -f
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    sudo dpkg -i google-chrome*.deb && \
    rm google-chrome-stable_current_amd64.deb
