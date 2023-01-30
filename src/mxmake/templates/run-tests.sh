{% extends "env.sh" %}

{% block env_content %}
{{ mxenv_path }}zope-testrunner --auto-color --auto-progress \
{% for path in testpaths %}
    --test-path={{ path }} \
{% endfor %}
    --module=$1
{% endblock %}
