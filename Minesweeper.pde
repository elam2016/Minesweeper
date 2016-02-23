import de.bezier.guido.*;
int NUM_ROWS = 40; int NUM_COLS = 40;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
public int screenSize;
public boolean gameOver = false;

void setup (){
    screenSize = (NUM_ROWS + NUM_COLS)*10;
    size(800, 800);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
  
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++)
        buttons[r][c] = new MSButton(r,c);
    }
    setBombs();
}
public void setBombs(){
  while(bombs.size() < 140){
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[row][col])){
        bombs.add(buttons[row][col]);
    }
  }
}

public void draw (){
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon(){
    for(int r=0; r < NUM_ROWS; r++){
        for(int c=0; c < NUM_COLS; c++){
            if(!(buttons[r][c].isClicked() && bombs.contains(buttons[r][c])))
                return false;
        }
    }
    return true;
}
public void displayLosingMessage(){
    gameOver = true;
    String loser = new String("GAME OVER!");
    for(int r=0; r < NUM_ROWS; r++){
        for(int c=0; c < NUM_COLS; c++){
            if(bombs.contains(buttons[r][c]))
                buttons[r][c].setLabel("B");
        }    
    }          
    for(int i=0; i < loser.length(); i++)
    {
        buttons[20][10 + i].end = true;
        buttons[20][10 + i].setLabel(loser.substring(i,i+1));
    } 
}
public void displayWinningMessage(){
    String winner = new String("WINNER!");
    for(int i=0; i < winner.length(); i++)
    {
        buttons[screenSize/2][screenSize/2 - 10 + i].end = true;
        buttons[screenSize/2][screenSize/2 - 10 + i].setLabel(winner.substring(i,i+1));
    } 
}

public class MSButton{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, end;
    private String label;
    
    public MSButton ( int rr, int cc ){
        width = screenSize/NUM_COLS;
        height = screenSize/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = end = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked(){
        return marked;
    }
    public boolean isClicked(){
        return clicked;
    }
    // called by manager
    
    public void mousePressed (){
        if(gameOver || isWon()) return;
        if(mouseButton == LEFT){
            clicked = true;
        }
        if(mouseButton == RIGHT && !isClicked()){
            marked = true;
        }
        else if(bombs.contains(this) && !marked){
            gameOver = true;
            displayLosingMessage();
        }
        else if(countBombs(r, c) > 0){
            setLabel(label + countBombs(r, c));
        }
        else if(c > 0){
            if(isValid(r,c-1) && buttons[r][c-1].clicked == false){buttons[r][c-1].mousePressed();}
            if(isValid(r,c+1) && buttons[r][c+1].clicked == false){buttons[r][c+1].mousePressed();}
            if(isValid(r-1,c) && buttons[r-1][c].clicked == false){buttons[r-1][c].mousePressed();}
            if(isValid(r+1,c) && buttons[r+1][c].clicked == false){buttons[r+1][c].mousePressed();}
            if(isValid(r-1,c-1) && buttons[r-1][c-1].clicked == false){buttons[r-1][c-1].mousePressed();}
            if(isValid(r-1,c+1) && buttons[r-1][c+1].clicked == false){buttons[r-1][c+1].mousePressed();}
            if(isValid(r+1,c-1) && buttons[r+1][c-1].clicked == false){buttons[r+1][c-1].mousePressed();}
            if(isValid(r+1,c+1) && buttons[r+1][c+1].clicked == false){buttons[r+1][c+1].mousePressed();}
        }
    }

    public void draw (){    
        if(marked)
            fill(0);
        else if(clicked && bombs.contains(this)) 
             fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel){
        label = newLabel;
    }
    public boolean isValid(int r, int c){
        if(r <= NUM_ROWS && c <= NUM_COLS)
          return true;
        return false;
    }
    public int countBombs(int row, int col){
      int numBombs = 0;
      if(isValid(row - 1, col - 1) && bombs.contains(buttons[row - 1][col - 1])){numBombs++;}
      if(isValid(row - 1, col) && bombs.contains(buttons[row - 1][col])){numBombs++;}
      if(isValid(row - 1, col + 1) && bombs.contains(buttons[row - 1][col + 1])){numBombs++;}
      if(isValid(row, col + 1) && bombs.contains(buttons[row][col + 1])){numBombs++;}
      if(isValid(row + 1, col + 1) && bombs.contains(buttons[row + 1][col + 1])){numBombs++;}
      if(isValid(row + 1, col) && bombs.contains(buttons[row + 1][col])){numBombs++;}
      if(isValid(row + 1, col - 1) && bombs.contains(buttons[row + 1][col - 1])){numBombs++;}
      if(isValid(row, col - 1) && bombs.contains(buttons[row][col - 1])){numBombs++;}
      return numBombs;
    }
}
