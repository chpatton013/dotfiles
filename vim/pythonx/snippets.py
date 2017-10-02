def camel_to_snake(camel, title=False):
    if title:
        snake = camel[0].upper()
    else:
        snake = camel[0].lower()

    word = False
    for c in camel[1:]:
        if c.isupper():
            snake += "_"
            word = True

        if word:
            if title:
                snake += c.upper()
            else:
                snake += c.lower()
            word = False
        else:
            snake += c.lower()

    return snake


def snake_to_camel(snake, title=False):
    if title:
        camel = snake[0].upper()
    else:
        camel = snake[0].lower()

    word = False
    for c in snake[1:]:
        if c == "_":
            word = True
            continue

        if word:
            camel += c.upper()
            word = False
        else:
            camel += c.lower()

    return camel


def file_to_symbol(name):
    return name.replace(".", "_").replace("-", "_")
