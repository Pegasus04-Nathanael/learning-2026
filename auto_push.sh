#!/bin/bash

# ============================================================
# Assistant Auto-Push GitHub - Version Corrigée
# ============================================================

# Configuration
GITHUB_USERNAME="Pegasus04-Nathanael"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m'

error_exit() {
    echo -e "${RED}❌ ERREUR: $1${NC}" >&2
    exit 1
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Assistant Auto-Push GitHub           ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"

# Vérifier Git
if ! command -v git &> /dev/null; then
    error_exit "Git n'est pas installé"
fi

# Initialiser Git
if [ ! -d ".git" ]; then
    warning "Initialisation du dépôt Git..."
    git init -b main || error_exit "Échec de l'initialisation"
    success "Dépôt Git initialisé"
else
    info "Dépôt Git déjà initialisé"
fi

# Configuration du Remote
REMOTE_URL=$(git remote get-url origin 2>/dev/null)

if [ -z "$REMOTE_URL" ]; then
    warning "Aucun remote configuré"
    
    # Demander le nom
    read -p "Nom du dépôt GitHub (ex: mon-projet): " REPO_NAME
    
    if [ -z "$REPO_NAME" ]; then
        error_exit "Nom de dépôt requis"
    fi
    
    # Normaliser le nom (remplacer espaces par tirets)
    REPO_NAME=$(echo "$REPO_NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    info "Nom normalisé: $REPO_NAME"
    
    # Vérifier GitHub CLI
    if command -v gh &> /dev/null; then
        info "Vérification de l'existence du dépôt..."
        
        if ! gh repo view "$GITHUB_USERNAME/$REPO_NAME" &>/dev/null; then
            warning "Le dépôt n'existe pas sur GitHub"
            read -p "Voulez-vous le créer automatiquement ? (o/n): " CREATE_REPO
            
            if [[ "$CREATE_REPO" =~ ^[oO]$ ]]; then
                read -p "Public ou Private ? (public/private): " VISIBILITY
                
                # Normaliser la visibilité
                VISIBILITY=$(echo "$VISIBILITY" | tr '[:upper:]' '[:lower:]')
                
                info "Création du dépôt sur GitHub..."
                
                # Créer le dépôt
                if [[ "$VISIBILITY" == "private" ]]; then
                    gh repo create "$GITHUB_USERNAME/$REPO_NAME" --private --source=. --remote=origin
                else
                    gh repo create "$GITHUB_USERNAME/$REPO_NAME" --public --source=. --remote=origin
                fi
                
                if [ $? -eq 0 ]; then
                    success "Dépôt créé avec succès sur GitHub !"
                else
                    error_exit "Échec de la création du dépôt"
                fi
            else
                warning "Créez d'abord le dépôt sur https://github.com/new"
                exit 1
            fi
        else
            info "Le dépôt existe déjà"
            git remote add origin "git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
        fi
    else
        warning "GitHub CLI (gh) non installé"
        echo -e "${CYAN}Installez-le: winget install --id GitHub.cli${NC}\n"
        warning "Créez le dépôt sur: https://github.com/new"
        read -p "Une fois créé, appuyez sur Entrée..."
        git remote add origin "git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
    fi
else
    info "Remote déjà configuré: $REMOTE_URL"
fi

# .gitignore
if [ ! -f ".gitignore" ]; then
    read -p "Créer un .gitignore basique ? (o/n): " CREATE_GITIGNORE
    
    if [[ "$CREATE_GITIGNORE" =~ ^[oO]$ ]]; then
        cat > .gitignore << 'EOF'
# Python
*.pyc
*.pyo
__pycache__/
venv/
.env

# IDE
.vscode/
.idea/

# Système
.DS_Store
Thumbs.db

# Gros fichiers
*.mp4
*.zip
*.rar
EOF
        success ".gitignore créé"
    fi
fi

# Ajout des fichiers
info "Ajout des fichiers..."
git add .

# Commit
if [ -z "$(git status --porcelain)" ]; then
    success "Rien à commiter"
else
    read -p "Message de commit (vide = auto): " COMMIT_MSG
    
    if [ -z "$COMMIT_MSG" ]; then
        COMMIT_MSG="🔄 Mise à jour - $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    
    git commit -m "$COMMIT_MSG" || error_exit "Échec du commit"
    success "Commit effectué"
fi

# Push
CURRENT_BRANCH=$(git branch --show-current)
info "Push vers GitHub (branche: $CURRENT_BRANCH)..."

if git push -u origin "$CURRENT_BRANCH" 2>&1; then
    success "🎉 Code envoyé sur GitHub !"
    echo -e "\n${CYAN}📎 https://github.com/$GITHUB_USERNAME/$REPO_NAME${NC}\n"
else
    error_exit "Échec du push"
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Terminé ✨                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"





# ============================================
# Auto-start SSH Agent avec mémorisation du mot de passe
# ============================================
env=~/.ssh/agent.env

agent_load_env () { 
    test -f "$env" && . "$env" >| /dev/null 
}

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

unset env