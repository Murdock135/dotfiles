# Function to check and install a tool
install_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo "$1 is not installed. Installing..."
        brew install "$1"
    else
        echo "$1 is already installed."
    fi
}

# List of tools to check and install
tools=("tree" "wget" "unzip")

for tool in "${tools[@]}"; do
    install_tool "$tool"
done
