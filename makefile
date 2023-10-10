# Define the default Docker image name
IMAGE := portfolio-nginx

# Targets
build:
ifeq ($(filter front,$(IMAGE)),front)
	docker build -t portfolio-$(IMAGE) front/
else ifeq ($(filter backend,$(IMAGE)),backend)
	docker build -t portfolio-$(IMAGE) back/
else ifeq ($(filter nginx,$(IMAGE)),nginx)
	docker build -t portfolio-$(IMAGE) nginx/
else
	$(error Invalid image name. Use 'front' or 'backend' or 'nginx' as the image name.\nYou entered $(IMAGE))
endif

start:
ifeq ($(filter front,$(IMAGE)),front)
	docker run --network mynetwork -p 3000:3000 -it --name portfolio-$(IMAGE)-container portfolio-$(IMAGE)
else ifeq ($(filter backend,$(IMAGE)),backend)
	docker run --network mynetwork -p 8080:8080 -it --name portfolio-$(IMAGE)-container portfolio-$(IMAGE)
else ifeq ($(filter nginx,$(IMAGE)),nginx)
	docker run --network mynetwork -p 80:80 -it --name portfolio-$(IMAGE)-container portfolio-$(IMAGE)
else
	$(error Invalid image name. Use 'front' or 'back' or 'nginx' as the image name.\nYou entered $(IMAGE))
endif


sh:
	docker exec -it portfolio-$(IMAGE)-container /bin/sh

remove:
	docker rm portfolio-$(IMAGE)-container
	docker rmi portfolio-$(IMAGE)
restart:
	make remove IMAGE=$(IMAGE)
	make build IMAGE=$(IMAGE) 
	make start IMAGE=$(IMAGE)
