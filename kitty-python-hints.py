import re
import os


def mark(text, args, Mark, extra_cli_args, *a):
    for idx, m in enumerate(
            re.finditer(r'"(/[0-9a-zA-Z._/-]*\.py)", line ([0-9]*)', text)):
        start, end = m.span()
        mark_text = text[start:end]
        path, line = mark_text[1:].split('", line ')
        yield Mark(idx, start, end, mark_text, {
            'path': path,
            'number': int(line)})


def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    matches, groupdicts = [], []
    for m, g in zip(data['match'], data['groupdicts']):
        if m:
            matches.append(m), groupdicts.append(g)
    for word, match_data in zip(matches, groupdicts):
        number = match_data['number']
        path = match_data['path']
        os.system(f'tmux new-window bash -c "nvim +{number} \'{path}\'"')
