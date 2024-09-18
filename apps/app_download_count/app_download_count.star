load("encoding/base64.star", "base64")
load("http.star", "http")
load("render.star", "render")
load("schema.star", "schema")

PLAYSTORE_ICON = "iVBORw0KGgoAAAANSUhEUgAAABQAAAAVCAYAAABG1c6oAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAG4SURBVHgBrdM9S8NAHMfx38WrCOIjgmt0stVBERdxqIjgqIubGhEXEdRXoF0EB1EHJ4UWfAG6CYo0Qp2ktIMPFZRkEV2EUNGhNTnvSh/S0tqk9TuUXHL3of9AAJ4cU9oHbhU//iFJ/HR+BGMkPRr2Rue1/uicgjoig+dMlig0sUg3H+GnMSJun7EGspEYCulwmWRfeL6WQVNj/IpNE9PSfNGFYF9MkeEiqfRGAeUsYwqHY77o/CYcVjSyvcL4uZ3QJbDA/fBJqCawLJqFGyxp8W4kpJY7I+GP7OPnY5BNYoUP44NB9gjZFVgJnaYvWPHEFVjQ2D2K4KpgKSqwbc+N/bGAw+wB62KReYfE/NacwJNsDTvdx5U3vKKD4j2BtIM/Ov58iaXIFZITLWjt+yy3JU5mYTgaWWCrkd3M9ftVF5KJFvtjg4+8wbEhsaBusFwCZSYx2nzJAzRin8xwNBt1i4kISOjtujPQHkjqpc+oG4wQqCb/WryqplY6Rx1iukXYolfVVVSJVsEMDh1waAsOo5UwDgWagP0eVTfgIg428QOpPJZ9T2I8HbU2tXehPPl7Tx/9sh919gs1vMl8n1IDmgAAAABJRU5ErkJggg=="
APPLESTORE_ICON = "iVBORw0KGgoAAAANSUhEUgAAABQAAAAVCAYAAABG1c6oAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAM3SURBVHgBjVQ7aFVBED2z78Y/eSks/CQaRFSChZ0GsbBQSxG0F/y0wV9tbFPExFYiWMdG8UNAUAtJICmCEkEUeTEJgkYNLzGSd+/dcWZ2780zNu5j353fzpyZnVlCXJ0vuC1F2pmD2vCfK5Gdyd6AZLJ2nBZURvq3/XmjRz69TFQFy7+KCSw/anbAekDkbDbCE7E5YZ4G+8EvJzYM0LZnjfPk6J46ghkEs2BJImTyxtKqd7WN+pJW1vOZxOXogWcJghCTykMwqGyohPdUKKNtcFnmqXLXQzseNbw5VLmTjy+jo7WF8eBoC4Y/e6GBrirhwniupQCXpeFYjpBNgpRXg+TRWYFAuI6NwNX9FXM4syyyhqcAHaE8ZbHDWYdMGLkq3UojF61syoHF38Dd9wGdrv630gM5RdtwhjOBanTwk5iy6eYQI+nVSGFpdimkNPrVY0RSt6BRFzOjkG6op7NGkrSpQBcjK9/qCNcOVszhyHSOoWNJ0GmZyqzMljQQZx6OQnrBUXTMKhP64gGH9i2E4Q+Sv4Dr3uZwaqfTwFgFwJEmK5PVUDZJ+5hh4bh9E/HVQwlmFxn9Ezm/+xZS7z2cCPJoqwCawOjXCWwSRXQkOw+piDOr0e3xDHMLnsZmPIbeZIb4QpcrL9Gy8uDiYqnjzrKFbm91fPNYQq3rCVXZXVvDFY3OeRRtNTXPOHfAGTc174sBwaUnDdRXQrMlhkyIjk2gU3sqWLu6tWZxHdkpiEdTXOluKeX1FUZVjtUzbw8A7er7xcXsKLqTe6Xw+yoYmsgwW+d/HgiR4fXl9WivOlx72sDIxxyLK2zjqJMW2qZsaMaVo4k4rWDuB2PWtv9rq931x6k5PysttbQcLzJeaEjZ5kigJGGgBl6lmPmeg+Ls25BGpEqMfcowVkvQ0ebAqSVojW7dvfvm0k+hq+SA5qfIniYf3dmQNvHFI1K+MlS8KDVHKQ2QFjT2UTkpaeh+4dkaWXl9PLSBjV6df8q96Tj3Dx3WNQZFMUmx4yk4kVR0grRxLRDzGr32rtkYAMGXYtK1bL5Vpth5o37e+cppT9wW84ipl3+I71rkI81UQwUva31b7iv7B7sn9FW7V+KKAAAAAElFTkSuQmCC"

def fetch_play_store_data(token, package_name):
    response = http.get(
        url = "https://playdeveloperreporting.googleapis.com/v1alpha/apps/" + package_name + "/downloads",
        headers = {"Authorization": "Bearer " + token},
        ttl_seconds = 60*10
    )
    if response.status_code == 200:
        data = response.json()
        return data["total_downloads"]  # Adjust field if necessary based on the actual response
    else:
        return None

def fetch_apple_store_data(token, app_id):
    response = http.get(
        url = "https://api.appstoreconnect.apple.com/v1/apps/" + app_id + "/metrics",
        headers = {"Authorization": "Bearer " + token},
        ttl_seconds = 60*10
    )
    if response.status_code == 200:
        data = response.json()
        return data["total_downloads"]  # Adjust field if necessary based on the actual response
    else:
        return None

def render_error(error):
    return render.Root(
        render.WrappedText(
            error,
        ),
    )

def main(config):
    apple_store_token = config.str("apple_store_token")
    apple_app_id = config.str("apple_app_id")
    google_play_token = config.str("google_play_token")
    play_store_package_id = config.str("play_store_package_id")

    # INSERT TEST CODE HERE

    apple_active = apple_store_token and apple_app_id
    google_active = google_play_token and play_store_package_id
    app_display_name = config.str("app_display_name", "Downloads")

    play_store_downloads = 2148000
    apple_store_downloads = 890000
    if google_active:
        play_store_downloads = fetch_play_store_data(google_play_token, play_store_package_id)
    if apple_active:
        apple_store_downloads = fetch_apple_store_data(apple_store_token, apple_app_id)

    if not google_active and not apple_active:
        google_active = True
        apple_active = True
        app_display_name = "Demo-App"

    entries_to_show = []
    if (google_active):
        entries_to_show.append(get_entry_tuple(not apple_active, play_store_downloads, PLAYSTORE_ICON))
    if (apple_active):
        entries_to_show.append(get_entry_tuple(not google_active, apple_store_downloads, APPLESTORE_ICON))

    if google_active and apple_active:
        main_content = render.Row(
            main_align = "space_evenly",
            cross_align = "center",
            expanded = True,
            children = [
                render.Column(
                    expanded = True,
                    main_align = "center",
                    cross_align = "center",
                    children =
                        cur_entry,
                )
                for cur_entry in entries_to_show
            ],
        )
    else:
        main_content = render.Row(
            entries_to_show[0],
            expanded = True,
            main_align = "center",
            cross_align = "center",
        )
    return render.Root(
        render.Column(
            children = [
                render.Padding(
                    render.Text(
                        app_display_name,
                        font = "CG-pixel-3x5-mono",
                    ),
                    pad = (0, 2, 0, 0),
                ),
                render.Column(
                    children = [
                        render.Padding(
                            main_content,
                            pad = (0, 4, 0, 0),
                        ),
                    ],
                    main_align = "center",
                    cross_align = "center",
                    expanded = True,
                ),
            ],
            expanded = True,
            cross_align = "center",
        ),
    )

def get_display_count(n):
    if not n and n != 0:
        return "n/a"
    suffix = ""
    if n >= 1000000:
        n /= 1000000
        suffix = "M"
    elif n >= 1000:
        n /= 1000
        suffix = "k"

    # Manual rounding to one decimal place by truncation
    n = int(n * 10) / 10.0

    n_str = "{}".format(int(n) if n == int(n) else n)
    return n_str + suffix

def get_entry_tuple(big_sized, download_count, icon):
    display_count = get_display_count(download_count)
    return [
        render.Image(
            src = base64.decode(icon),
            height = 16 if big_sized else 10,
        ),
        render.Padding(
            render.Text(
                str(display_count),
                font="6x13" if big_sized else "tb-8"
            ),
            pad = 2,
        ),
    ]

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "google_play_token",
                name = "Google Play API Token",
                desc = "Your Google Play API Token",
                icon = "lock",
            ),
            schema.Text(
                id = "apple_store_token",
                name = "Apple Store API Token",
                desc = "Your Apple Store API Token",
                icon = "lock",
            ),
            schema.Text(
                id = "play_store_package_id",
                name = "App Package Name",
                desc = "Your app's package name for Google Play Store",
                icon = "magnifyingGlass",
            ),
            schema.Text(
                id = "apple_app_id",
                name = "Apple App ID",
                desc = "Your app's ID for Apple App Store",
                icon = "magnifyingGlass",
            ),
            schema.Text(
                id = "app_display_name",
                name = "App Display Name",
                desc = "Your app's display name",
                icon = "display",
                default = "Downloads",
            ),
        ],
    )
