## Local Edition Guide
### System Requirements
  - **CPU:** AMD x86_64, 2.5 GHz or higher (6 cores / 12 threads recommended)
  - **Memory:** 16 GB RAM
  - **Storage:** 10 GB available SSD/NVMe space

### Usage
```shell
# 1. Load the Docker Image
docker load -i himitsu_core_v1.1.2.tar.gz

# 2. Start the Container
docker run --name himitsu_core -d -it himitsu_core:v1.1.2

# 3. Upload Your Shell Script (The filename must be "launcher.sh")
docker cp launcher.sh himitsu_core:/var/work/

# 4. Build the Protected Binary (10–20 min)
docker exec himitsu_core /var/work/compile.sh

# 5. Download the Generated Binary
docker cp himitsu_core:/var/work/safeLauncher .
```