FROM app/php:1.0.0

USER root

COPY .docker/dev/cron.sh /root/cron.sh

RUN rm -f /etc/crontabs/root &&\
    touch /etc/crontabs/root &&\
    chown -R www-data:www-data /var/www &&\
    chmod -R 0774 /var/www

CMD ["/root/cron.sh"]
