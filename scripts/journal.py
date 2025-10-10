#!/usr/bin/env python3

import subprocess
import argparse
from datetime import datetime, timedelta
from pathlib import Path

def get_date(args):
    """Bepaal de juiste datum op basis van de CLI arguments."""
    if args.morgen:
        return datetime.now() + timedelta(days=1)
    elif args.gisteren:
        return datetime.now() - timedelta(days=1)
    elif args.date:
        return datetime.strptime(args.date, "%Y-%m-%d")
    else:
        return datetime.now()



def main():
    parser = argparse.ArgumentParser(
        description="Open of maak een journal bestand voor vandaag, morgen of een specifieke datum."
    )
    parser.add_argument(
        "-m", "--morgen", action="store_true",
        help="Gebruik de datum van morgen"
    )
    parser.add_argument(
        "-g", "--gisteren", action="store_true",
        help="Gebruik de datum van gisteren"
    )
    parser.add_argument(
        "-d", "--date", metavar="YYYY-MM-DD",
        help="Gebruik een specifieke datum (bijv. 2025-10-02)"
    )

    args = parser.parse_args()
    date = get_date(args)

    date_str = date.strftime("%Y-%m-%d")
    year_str = date.strftime("%Y")

    # Bestandslocatie
    journal_file = Path.home() / "Documenten" / "Journal" / year_str / f"{date_str}.md"

    # Zorg dat de map bestaat
    journal_file.parent.mkdir(parents=True, exist_ok=True)

    # 2. Voeg header toe als het bestand nog niet bestaat
    if not journal_file.exists():
        with journal_file.open("w") as f:
            f.write(f"# {date_str}\n\n")

    # 3. Voeg subheader met tijd toe bij iedere run
    # DISABLED FOR NOW!
    # Ik vind het denk ik toch prettiger een bestand te hebben waar ik zelf dingen
    # aan kan toevoegen als ik dat zelf wil.

    # current_time = datetime.now().strftime("%H:%M")
    # with journal_file.open("a") as f:
    #     f.write(f"## {current_time}\n\n")

    # 4. Open in Neovim op de laatste regel
    subprocess.run(["hx", str(journal_file)])
    # subprocess.run(["nvim", "+normal G$", str(journal_file)])


if __name__ == "__main__":
    main()
