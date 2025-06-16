#!/bin/bash

# Verifica que se pase el archivo
if [ -z "$1" ]; then
  echo "❌ Debes pasar un archivo .cpp"
  echo "👉 Uso: ./compile.sh archivo.cpp"
  exit 1
fi

# Obtiene el nombre base sin extensión
BASENAME=$(basename "$1" .cpp)

# Detectar sistema operativo
OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
  # macOS
  INCLUDE_PATH="/opt/homebrew/Cellar/sfml@2/2.6.2_1/include"
  LIB_PATH="/opt/homebrew/Cellar/sfml@2/2.6.2_1/lib"
  FRAMEWORKS="-framework OpenGL -framework Foundation -framework AppKit"
  STATIC_LIBS=""
elif [[ "$OS" == "Linux" ]]; then
  # Linux (ej. WSL)
  INCLUDE_PATH="/usr/include"
  LIB_PATH="/usr/lib"
  FRAMEWORKS=""
  STATIC_LIBS="-lGL -lX11 -lpthread -lXrandr -lXi -lXxf86vm -lXcursor"
elif [[ "$OS" == "MINGW"* || "$OS" == "MSYS"* || "$OS" == "CYGWIN"* ]]; then
  # Windows usando MinGW o Git Bash
  INCLUDE_PATH="/c/SFML/include"
  LIB_PATH="/c/SFML/lib"
  FRAMEWORKS=""
  STATIC_LIBS="-lgdi32 -lopengl32 -lsfml-main"
else
  echo "❌ Sistema no soportado: $OS"
  exit 1
fi

# Comando de compilación
g++ -std=c++17 "$1" \
  -I"$INCLUDE_PATH" \
  -L"$LIB_PATH" \
  -lsfml-graphics -lsfml-window -lsfml-system \
  $STATIC_LIBS $FRAMEWORKS \
  -o "$BASENAME"

# Verifica resultado
if [ $? -eq 0 ]; then
  echo "✅ Compilación exitosa: ejecuta ./$BASENAME"
else
  echo "❌ Error en la compilación"
fi
