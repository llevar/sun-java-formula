{%- from 'sun-java/settings.sls' import java with context %}

# require a source_url - there is no default download location for a jdk
{%- if java.source_url is defined %}

{{ java.prefix }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

unpack-jdk-tarball:
  cmd.run:
    - name: curl {{ java.dl_opts }} '{{ java.source_url }}' | tar xz --no-same-owner
    - cwd: {{ java.prefix }}
    - unless: test -d {{ java.java_real_home }}
    - require:
      - file: {{ java.prefix }}
  alternatives.install:
    - name: java
    - link: /usr/bin/java
    - path: {{ java.java_real_home }}/bin/java
    - priority: 2000
  file.symlink:
    - name: /usr/lib/java
    - target: {{ java.java_real_home }}

{%- endif %}
