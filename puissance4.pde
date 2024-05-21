int[][] board = new int[7][6];
int currentPlayer = 1;
boolean isDropping = false;  
boolean gameEnded = false; 
int winnerTimer = 120;
PVector[] indexWin = new PVector[4];
int winner = 0;
float cellX, cellY;
int cursorCol = 3;
int dropCol, dropRow;
float dropY;

void setup() {
  size(1000, 900);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  ellipseMode(RADIUS);
    // Initialisation de la grille avec des zéros
  for (int i = 0; i< 7; i++) {
    for (int j = 0; j<6; j++) {
      board[i][j] = 0;
    }
  }
}

void draw() {
  background(0);   
  drawBoard();

  if (isDropping) {
    animateDrop();
  } else {
    // Dessiner l'ellipse en haut de l'écran
    if (currentPlayer == 1) {
      drawGradient(cursorCol * (width / 7) + (width / 14), 80, 200, 90, 90);  // Dessiner l'ellipse avec un dégradé bleu
    } else {
      drawGradient(cursorCol * (width / 7) + (width / 14), 80, 120, 90, 90);  // Dessiner l'ellipse avec un dégradé vert
    }
  }

  // Message de victoire 
  if (gameEnded) {
    showWinner((currentPlayer == 1) ? "Player 1" : "Player 2"); // gagnant actuel
    winnerTimer--; // temporisateur
    // Redémarrer le jeu après un certain temps
    if (winnerTimer <= 0) {
      resetGame(); // Redémarrer le jeu
    }
  }
}
void animateDrop() {
  float targetY = dropRow * ((height - 100) / 6) + ((height - 100) / 12) + 100;
  if (dropY < targetY) {
    dropY += 15; // Vitesse de chute
    if (dropY > targetY) {
      dropY = targetY;
    }
  } else {
    board[dropCol][dropRow] = currentPlayer;
    winner = checkWinner(dropCol, dropRow, currentPlayer);
    if (winner == 1 || winner == 2) {
      gameEnded = true; 
      winnerTimer = 120;
    } else {
      currentPlayer = (currentPlayer == 1) ? 2 : 1;
    }
    isDropping = false;
  }

  if (currentPlayer == 1) {
    drawGradient(dropCol * (width / 7) + (width / 14), dropY, 200, 90, 90);  // Dessiner l'ellipse avec un dégradé bleu
  } else {
    drawGradient(dropCol * (width / 7) + (width / 14), dropY, 120, 90, 90);  // Dessiner l'ellipse avec un dégradé vert
  }
}

void resetGame() {
  gameEnded = false;
  winnerTimer = 120;
  currentPlayer = 1;
  
  // Réinitialiser la grille avec des zéros
  for (int i = 0; i<7; i++) {
    for (int j = 0; j <6; j++) {
      board[i][j] = 0;
    }
  }
}
void dropDisc(int col) {
  if (gameEnded) {
    return;
  }
  if (col >= 0 && col < 7 && board[col][0] == 0) {
    int row = 5;
    while (board[col][row] != 0) {
      row--;
    }
    board[col][row] = currentPlayer;

    winner = checkWinner(col, row, currentPlayer);
    if (winner == 1 || winner == 2) {
      gameEnded = true; 
      winnerTimer = 120; 
    } else {
      currentPlayer = (currentPlayer == 1) ? 2 : 1;
    }
  }
}

void keyPressed() {
  if (keyCode == LEFT) {
    cursorCol = max(0, cursorCol - 1);
  } else if (keyCode == RIGHT) {
    cursorCol = min(6, cursorCol + 1);
  } else if (keyCode == ENTER && !isDropping) {
    startDrop(cursorCol); // initier la chute du jeton
  }
}
void startDrop(int col) {
  if (gameEnded) {
    return;
  }
  if (col >= 0 && col < 7 && board[col][0] == 0) {
    dropCol = col;
    dropRow = 5;
    while (dropRow > 0 && board[col][dropRow] != 0) {
      dropRow--;
    }
    dropY = 60; // Position de départ du jeton en haut de l'écran
    isDropping = true;
  }
}

void drawBoard() {
 
  float cellWidth = width / 7; // Largeur de la cellule
  float cellHeight = (height - 100) / 6; // Hauteur de la cellule

  // Dessin de la grille et des jetons
  for (int i = 0; i < 7; i++) {
    for (int j = 0; j < 6; j++) {
      fill(255);
      // coordonnées x et y du centre de la cellule
      cellX = i * cellWidth + cellWidth / 2;
      cellY = j * cellHeight + cellHeight / 2 + 100;

      if (board[i][j] == 1) {
        drawGradient(cellX, cellY, 200, 90, 90);  // Dégradé pour le joueur 1 (bleu)
      } else if (board[i][j] == 2) {
        drawGradient(cellX, cellY, 120, 90, 90);  // Dégradé pour le joueur 2 (vert)
      }
    }
  }
  if (gameEnded) {
    winLighted(winner);
  }

  // Dessin des lignes de la grille et surbrillance de la colonne sélectionnée
  for (int i = 0; i < 8; i++) {
    if (i == cursorCol || i == cursorCol + 1) {
      if (currentPlayer == 1) {
        stroke(200, 90, 90); // Couleur pour le joueur 1 (bleu)
      } else {
        stroke(120, 90, 90); // Couleur pour le joueur 2 (vert)
      }
    } else {
      stroke(0, 0, 50);
    }
    strokeWeight(5);
    strokeCap(ROUND);
    line(i * cellWidth, 185, i * cellWidth, height - 50);
    noStroke();
  }
}

void winLighted(int player){
    float cellWidth = width / 7; // Largeur de la cellule
    float cellHeight = (height - 100) / 6;
    for(int i=0; i<7; i++){
      for(int j=0; j<6; j++){
      cellX = i * cellWidth + cellWidth / 2;
      cellY = j * cellHeight + cellHeight / 2 + 100;
        if(board[i][j]!=0){
        boolean pass = true;
        for(int k=0; k<4; k++){
          if(indexWin[k].x == i && indexWin[k].y == j ){
            pass = false;
            break;   
          }}
          if(pass){
            {if (board[i][j] == 1) {
                drawGradient(cellX, cellY, 200, 130, 25);  // Dégradé pour le joueur 1 (bleu)
              } else{
                drawGradient(cellX, cellY, 120, 130, 25);  // Dégradé pour le joueur 2 (vert)
      }}}         
        }
      }
    }
}
void drawGradient(float x, float y, float startHue, int val1, int val2) {
  int radius = (int)((width / 7) / 2 * 0.95);
  for (int r = radius; r >0; --r) {
    fill(startHue, val1, val2);
    ellipse(x, y, r, r);
    startHue = (startHue + 1) % 360;
  }
}
int findDepHorizontale(int col, int row, int player){
  int depX=col;
   while(depX-1 >= 0 && depX-1 < 7 && board[depX-1][row] == player){
    depX -= 1;
  }
  return depX;
}
int findDepVerticale(int col, int row, int player){
  int depY=row;
   while(depY+1 >= 0 && depY+1 < 6 && board[col][depY+1] == player){ 
    depY += 1;
  }
  return depY;
}
PVector findDepDiagonale1(int col, int row, int player){
  int depX=col, depY=row;
  while(depX-1 >= 0 && depY+1 >= 0 && depX-1<7 && depY+1<6 && board[depX-1][depY+1] == player){
    depX -= 1;
    depY += 1;
  }
  return new PVector(depX, depY);
}
PVector findDepDiagonale2(int col, int row, int player){
  int depX=col, depY=row;
  while(depX+1 >= 0 && depY+1 >= 0 && depX+1<7 && depY+1<6 && board[depX+1][depY+1] == player){
    depX += 1;
    depY += 1;
  }
  return new PVector(depX, depY);
}
int checkWinner(int col, int row, int player){
  //Horizontale
  int depX, depY;
  depX = findDepHorizontale(col, row, player);
  depY = row;
  int sum1 = 0;
  int sum2 = 0;
  for(int i=0; i<4; i++){
   if(depX+i >= 0 && depX+i < 7 && board[depX+i][depY]==1){
     sum1 += 1;
     if(sum1 == 4){
       indexWin[0] = new PVector(depX, depY);
      for(int k=1; k<4; k++)
      {
        depX += 1;
        indexWin[k] = new PVector(depX, depY);
      }
      return 1;
     }
   }
   if(depX+i >= 0 && depX+i < 7 && board[depX+i][depY]==2){
     sum2 += 2;
     if(sum2 == 8){
       indexWin[0] = new PVector(depX, depY);
      for(int k=1; k<4; k++)
      {
        depX += 1;
        indexWin[k] = new PVector(depX, depY);
      }
       return 2;
     }
   }
  }
  //Verticale
  depX = col;
  depY = findDepVerticale(col, row, player);
  sum1 = 0;
  sum2 = 0;
  for(int i=0; i<4; i++){
   if(depY-i >= 0 && depY-i < 6 && board[depX][depY-i]==1){
     sum1 += 1;
     if(sum1 == 4){
      indexWin[0] = new PVector(depX, depY);
      for(int k=1; k<4; k++)
      {
        depY -= 1;
        indexWin[k] = new PVector(depX, depY);
      }
      return 1;
    }
   }
   if(depY-i >= 0 && depY-i < 6 && board[depX][depY-i]==2){
     sum2 += 2;
     if(sum2 == 8){
      indexWin[0] = new PVector(depX, depY);
      for(int k=1; k<4; k++)
      {
        depY -= 1;
        indexWin[k] = new PVector(depX, depY);

      }
       return 2;
     } 
   }
  }
  //diagonale1
  PVector startP1 = findDepDiagonale1(col, row, player);
  depX = (int)startP1.x;
  depY = (int)startP1.y;
  sum1 = 0;
  sum2 = 0;
  for(int i=0; i<4; i++){
   if(depX+i >= 0 && depX+i < 7 && depY-i >= 0 && depY-i < 6 && board[depX+i][depY-i]==1){
     sum1 += 1;
     if(sum1 == 4){
      indexWin[0] = new PVector(depX, depY);
      for(int k=1; k<4; k++)
      {
        depX += 1;
        depY -= 1;
        indexWin[k] = new PVector(depX, depY);
      }
      return 1;
    }
   }
   if(depX+i >= 0 && depX+i < 7 && depY-i >= 0 && depY-i < 6 && board[depX+i][depY-i]==2){
     sum2 += 2;
     if(sum2 == 8){
       indexWin[0] = new PVector(depX, depY);
      for(int k=1; k<4; k++)
      {
        depX += 1;
        depY -= 1;
        indexWin[k] = new PVector(depX, depY);
      }
       return 2;
     }
   }
  }
  //diagonale2
  PVector startP2 = findDepDiagonale2(col, row, player);
  depX = (int)startP2.x;
  depY = (int)startP2.y;
  sum1 = 0;
  sum2 = 0;
  for(int i=0; i<4; i++){
   if(depX-i >= 0 && depX-i < 7 && depY-i >= 0 && depY-i < 6 && board[depX-i][depY-i]==1){
     sum1 += 1;
     if(sum1 == 4){
       indexWin[0] = new PVector(depX, depY);
      for(int k=1; k<4; k++)
      {
        depX -= 1;
        depY -= 1;
        indexWin[k] = new PVector(depX, depY);
      }
      return 1;
    }
   }
   if(depX-i >= 0 && depX-i < 7 && depY-i >= 0 && depY-i < 6 && board[depX-i][depY-i]==2){
     sum2 += 2;
     if(sum2 == 8){
       indexWin[0] = new PVector(depX, depY);
      for(int k=1; k<4; k++)
      {
        depX -= 1;
        depY -= 1;
        indexWin[k] = new PVector(depX, depY);
      }
       return 2;
     }
   }
  }
  return 0;
}

void showWinner(String player) {
  textSize(32); 
  textAlign(CENTER, CENTER); 
  fill(255);
  rectMode(CENTER);
  rect(width / 2, 60, 400, 100, 20);
  fill(0);
  text(player +" wins !", width / 2, 60); 
}
