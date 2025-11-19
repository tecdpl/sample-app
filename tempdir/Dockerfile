FROM python

# Evita cache e desativa progress bar "rich" do pip (corrige erro de thread)
ENV PIP_NO_CACHE_DIR=1 \
    PIP_PROGRESS_BAR=off

RUN pip install --no-cache-dir --progress-bar off flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/

EXPOSE 5050
CMD python3 /home/myapp/sample_app.py
