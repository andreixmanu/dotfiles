#!/bin/bash

# Define the power menu options
options=("Shutdown" "Restart" "Suspend" "Logout" "Lock")

# Prompt the user to select an option
select option in "${options[@]}"; do
    case $option in
        "Shutdown")
            # Execute the shutdown command
            systemctl poweroff
            ;;
        "Restart")
            # Execute the restart command
            systemctl reboot
            ;;
        "Suspend")
            # Execute the suspend command
            systemctl suspend
            ;;
        "Logout")
            # Execute the logout command
            swaymsg exit
            ;;
        "Lock")
            # Execute the lock command
            swaylock
            ;;
        *)
            # Invalid option selected
            echo "Invalid option. Please try again."
            ;;
    esac
    break
done