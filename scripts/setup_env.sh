#!/bin/bash

# Script para configurar las variables de entorno de Supabase
# Uso: ./scripts/setup_env.sh

echo "🔧 Configurando variables de entorno para Supabase..."

# Verificar si el archivo .env ya existe
if [ -f ".env" ]; then
    echo "⚠️  El archivo .env ya existe."
    read -p "¿Deseas sobrescribirlo? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Configuración cancelada."
        exit 1
    fi
fi

# Crear archivo .env desde la plantilla
cp env.example .env

echo "✅ Archivo .env creado desde env.example"
echo ""
echo "📝 Por favor, edita el archivo .env con tus credenciales reales:"
echo "   1. SUPABASE_URL: URL de tu proyecto Supabase"
echo "   2. SUPABASE_PUBLISHABLE_KEY: Clave publishable (recomendada para móviles)"
echo "   3. ENVIRONMENT: development o production"
echo ""
echo "🔗 Para obtener las credenciales:"
echo "   1. Ve a https://supabase.com"
echo "   2. Selecciona tu proyecto"
echo "   3. Ve a Settings → API"
echo "   4. Copia Project URL y publishable key (recomendada para móviles)"
echo ""
echo "⚠️  IMPORTANTE: Nunca subas el archivo .env al repositorio!"
echo ""
echo "🚀 Una vez configurado, ejecuta: flutter pub get"
