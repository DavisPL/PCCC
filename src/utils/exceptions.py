class ExceptionHelper:
    def __init__(self):
        self.value = None
    def handle_none(self):
        try:
            result = self.value
        except TypeError as e:
            print(e)
            
        