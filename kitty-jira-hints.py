import re
import os


def mark(text, args, Mark, extra_cli_args, *a):
    for idx, m in enumerate(
            re.finditer(r'([A-Z][A-Z]*-[0-9][0-9]*)', text)):
        start, end = m.span()
        mark_text = text[start:end]
        yield Mark(idx, start, end, mark_text, {'issue': mark_text})


def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    matches, groupdicts = [], []
    for m, g in zip(data['match'], data['groupdicts']):
        if m:
            matches.append(m), groupdicts.append(g)
    for word, match_data in zip(matches, groupdicts):
        number = match_data['issue']
        boss.open_url(f'https://coopengo.atlassian.net/browse/{number}')
