# Определяем компилятор и линковщик
CC = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

# Определяем целевой микроконтроллер и флаги компиляции
MCU = atmega328p
CFLAGS = -Wall -g -Os -mmcu=$(MCU)

# Имя выходных файлов
TARGET = IRF
BIN_FILE = $(TARGET).bin
HEX_FILE = $(TARGET).hex

# Правило по умолчанию для сборки программы
all: $(HEX_FILE)

# Правило для компиляции .c файла в .bin файл
$(BIN_FILE): $(TARGET).o
	$(CC) $(CFLAGS) -o $@ $^

# Правило для создания .hex файла из .bin файла
$(HEX_FILE): $(BIN_FILE)
	$(OBJCOPY) -O ihex $< $@

# Правило для компиляции исходного файла в объектный файл
$(TARGET).o: $(TARGET).c
	$(CC) $(CFLAGS) -c $< -o $@

# Правило для загрузки HEX файла на микроконтроллер
flash: $(HEX_FILE)
	$(AVRDUDE) -p $(MCU) -c stk500 -U flash:w:$(HEX_FILE):i -F -P COM6 -B12 -v

# Правило для очистки скомпилированных файлов
clean:
	rm -f $(TARGET).o $(BIN_FILE) $(HEX_FILE)

