FROM nevinee/nginxwebui-base
COPY src/target/nginxWebUI-*.jar /home/nginxWebUI.jar
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh
VOLUME ["/home/nginxWebUI"]
ENTRYPOINT ["tini", "entrypoint.sh"]
