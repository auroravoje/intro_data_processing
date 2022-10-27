# Exercise 2
#
# Tidy the following data frame:
#
# |   hour | NRK1          | TV2             | TVNorge             |
# |-------:|:--------------|:----------------|:--------------------|
# |     19 | Dagsrevyen    | Kjære landsmenn | The Big Bang Theory |
# |     20 | Beat for beat | Forræder        | Alltid beredt       |
# |     21 | Nytt på nytt  | 21-nyhetene     | Kongen befaler      |
# |     22 | Lindmo        | Farfar          | Praktisk info       |

import pandas as pd

schedule = pd.DataFrame(
    {
        "hour": [19, 20, 21, 22],
        "NRK1": ["Dagsrevyen", "Beat for beat", "Nytt på nytt", "Lindmo"],
        "TV2": ["Kjære landsmenn", "Forræder", "21-nyhetene", "Farfar"],
        "TVNorge": [
            "The Big Bang Theory",
            "Alltid beredt",
            "Kongen befaler",
            "Praktisk info",
        ],
    }
)
