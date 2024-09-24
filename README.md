# TuneIn TUI

TuneIn TUI is a lightweight terminal user interface (TUI) application for browsing and playing radio stations from TuneIn Radio. It provides a fast and intuitive way to search, browse, and play radio stations directly from your terminal without the need for a web browser. The application features a scrollable list of stations, keyboard navigation, and integration with VLC media player for seamless audio playback.

## Features

- **Search**: Quickly search for radio stations using keywords.
- **Browse**: View a list of available stations based on your search criteria.
- **Play**: Stream radio stations directly in VLC media player.
- **Keyboard Navigation**: Navigate the interface using intuitive keyboard shortcuts inspired by Vim (e.g., `hjkl` for movement).
- **Lightweight**: Minimal dependencies, designed for speed and ease of use.

## Installation

### Prerequisites

- **OCaml**: Make sure OCaml is installed on your system. You can install it via [opam](https://opam.ocaml.org/):
  ```bash
    opam install ocaml
  ```

- **Opam Packages**: Install the necessary opam packages:

    ```bash
    opam install dune lwt cohttp-lwt-unix lambda-term xmlm
    ```


- **VLC Media Player**: The application uses VLC for streaming radio stations. Install VLC on your system if it's not already installed:

    - On Ubuntu/Debian
    ```bash
    sudo apt-get install vlc
    ```
    - On Arch-based systems
    ```bash
    pacman -S install vlc
    ```
    - On macOS (using Homebrew) 
    ```bash
    brew install vlc  
    ```


## Build and Run

1. Clone the repository:

    ```bash
    git clone git@github.com:your-username/tunein-tui.git
    cd tunein-tui
    ```

2. Build the application using dune:

    ```bash
    dune build
    ```

3. Run the application:

    ```bash
    dune exec ./_build/default/bin/tunein_tui.exe
    ```


## Usage

Once the application is running, you can use the following keyboard shortcuts to interact with the TUI:

- / (Slash): Open the search bar to search for radio stations.
- Enter: Confirm search or select a radio station to play.
- hjkl: Navigate through the list of stations.
- Esc: Exit the current view or go back.
- q: Quit the application.

## Troubleshooting

**VLC Not Found**
If VLC is not found, ensure it's installed and accessible in your system's PATH. You can check this by running:
```bash
which vlc
```

If the output is empty, make sure to install VLC and add it to your PATH.


## Parsing Errors

If the application fails to parse the XML response from TuneIn, make sure that the API endpoint used for fetching the radio stations is up and running.



