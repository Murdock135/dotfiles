sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

echo "User $USER has been added to the 'docker' group. Log out and log back in to make that take effect. Then you can start using docker!"
echo "Example: docker run -it --rm archlinux bash -c 'echo hello world'"
