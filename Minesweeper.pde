import de.bezier.guido.*;
int NUM_ROWS = 40; int NUM_COLS = 40;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
public int screenSize;
public boolean gameOver = false;
public int bombCount = bombs.size();
public int markCount = 0;

void setup (){
    screenSize = (NUM_ROWS + NUM_COLS)*10;
    size(800, 820);
    if(!gameOver){
        textAlign(CENTER,CENTER);
        fill(255);
        text("Spots marked: " + markCount, 150, 750); 
        // make the manager
        Interactive.make( this );
      
        buttons = new MSButton[NUM_ROWS][NUM_COLS];
        for(int r = 0; r < NUM_ROWS; r++){
          for(int c = 0; c < NUM_COLS; c++)
            buttons[r][c] = new MSButton(r,c);
        }
        setBombs();
    }
}

public void setBombs(){
  while(bombs.size() < 120){
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[row][col]) && buttons[row][col].isValid(row,col)){
        bombs.add(buttons[row][col]);
    }
  }
}

public void keyPressed(){
    gameOver = false;
    for(int rr = 0; rr < NUM_ROWS; rr++){
        for(int cc = 0; cc < NUM_COLS; cc++){
            bombs.remove(buttons[rr][cc]);
            buttons[rr][cc].clicked = false;
            buttons[rr][cc].marked = false;
            buttons[rr][cc].setLabel("");
        }
    }
    setBombs();
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
    fill(255);
    String loser = new String("GAME OVER!");
    for(int r=0; r < NUM_ROWS; r++){
        for(int c=0; c < NUM_COLS; c++){
            if(bombs.contains(buttons[r][c])){
                buttons[r][c].setLabel("B");
            }
        }    
    }          
    for(int i=0; i < loser.length(); i++)
    {
        buttons[NUM_ROWS/2][(NUM_COLS/2) - 5 + i].stop = true;
        buttons[NUM_ROWS/2][(NUM_COLS/2) - 5 + i].setLabel(loser.substring(i,i+1));
    } 
    fill(0);
}

public void displayWinningMessage(){
    fill(255);
    String winner = new String("WINNER!");
    for(int i=0; i < winner.length(); i++)
    {
        buttons[NUM_ROWS/2][(NUM_COLS/2) - 5 + i].stop = true;
        buttons[NUM_ROWS/2][(NUM_COLS/2) - 5 + i].setLabel(winner.substring(i,i+1));
    } 
}

public class MSButton{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, stop;
    private String label;
    
    public MSButton ( int rr, int cc ){
        width = screenSize/NUM_COLS;
        height = screenSize/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = stop = false;
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
        if(mouseButton == LEFT && label.equals("") && !isMarked()){
            clicked = true;
        }
        if(mouseButton == RIGHT && !isClicked()){
            marked = !marked;
            markCount++;
        }
        else if(bombs.contains(this) && !marked){
            gameOver = true;
            displayLosingMessage();
        }
        else if(countBombs(r, c) > 0 && label.equals("")){
            setLabel(label + countBombs(r, c));
        }
        else{
            if(isValid(r,c-1) && label.equals("") && buttons[r][c-1].isClicked() == false)
                buttons[r][c-1].mousePressed();
            if(isValid(r-1,c) && label.equals("") && buttons[r-1][c].isClicked() == false)
                buttons[r-1][c].mousePressed();
            if(isValid(r,c+1) && label.equals("") && buttons[r][c+1].isClicked() == false)
                buttons[r][c+1].mousePressed();
            if(isValid(r+1,c) && label.equals("") && buttons[r+1][c].isClicked() == false)
                buttons[r+1][c].mousePressed();
        }
    }

    public void draw (){    
        if(marked)
            fill(0);
        else if(clicked && bombs.contains(this)){
            fill(255,0,0);
        }
        else if(clicked)
            fill(0, 190, 190);
        else 
            fill(0, 95, 95);
        if(stop && gameOver)
            fill(0, 0, 255);
        rect(x, y, width, height);
        fill(255);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel){
        label = newLabel;
    }
    public boolean isValid(int r, int c){
        if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
            return true;
        return false;
    }
    public int countBombs(int row, int col){
      int numBombs = 0;
          for(int rr = -1; rr < 2; rr++){
              for(int cc = -1; cc < 2; cc++){
                  if(isValid(row+rr,col+cc) && bombs.contains(buttons[row+rr][col+cc]))
                      numBombs++;
              }
          }
      return numBombs;
    }
}
