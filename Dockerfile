FROM composer

LABEL "repository"="http://github.com/IonBazan/composer-diff"
LABEL "homepage"="http://github.com/IonBazan"
LABEL "maintainer"="Ion Bazan <ion.bazan@gmail.com>"
LABEL "description"="Compares composer.lock changes and generates Markdown report so you can use it in PR description."

RUN composer global require ion-bazan/composer-diff

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
