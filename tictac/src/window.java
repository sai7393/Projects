import java.util.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
public class window {

	static int player1=0;
	static int player2=0;
	static int comp=0;
	static int MAXINT = 1000;
	static int m=3;
	static int flag = 0;			//flag =1 if win
	static JFrame mainframe;
	static JPanel panel;
	static int lastposi=0;
	static int lastposj=0;
	
	static JButton[][] crossbuttons;
	JLabel statuslabel,statuslabel1;
	private int[][] clicked;
	Container mainpane;
	int turn,num_clicked;
	static String howcan = "The Rules of the game are as follows : \n" +
			" Its a two player game where player 1 puts an X and player 2 puts an O.\n" +
			" A player wins if he makes a line(row or column or diagonal) full of his symbols	";
	
	window()
	{
		;
	}
	

	public void creategui()
	{
	
			mainframe = new JFrame("TIC TAC TOE");
			mainframe.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
			// We should set a minimum size to make the GUI look a little nicer
			// while making it.
			mainframe.setMinimumSize(new Dimension(500, 400));
			//mainframe.pack();
			//mainframe.setVisible(true);
			//overall frame drawn
			
			//container
			mainpane = mainframe.getContentPane();
			
			//draw menu bar
			JMenuBar mbar = new JMenuBar();
			
			//create a menu called file
			JMenu file = new JMenu("File");
			
			//add menu items to it called "new game" and "quit"
			JMenuItem New1 = new JMenuItem("new 2 player 3*3 game");
			//add "new game" to the menu "file"
			file.add(New1);
			New1.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent arg0) {
					//n = 3;
					 m = 3;
					panel.setLayout(new GridLayout(m,m));
					newgame();
				}	
				
				
			}
				
			);
			JMenuItem New2 = new JMenuItem("new 2 player 4*4 game");
			//add "new game" to the menu "file"
			file.add(New2);
			New2.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent arg0) {
					//n = 4;
					 m = 4;
					panel.setLayout(new GridLayout(m,m));
					newgame();
				}	
				
				
			}
				
			);
			JMenuItem New3 = new JMenuItem("new 2 player 5*5 game");
			//add "new game" to the menu "file"
			file.add(New3);
			New3.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent arg0) {
					//n = 5;
					 m = 5;
					panel.setLayout(new GridLayout(m,m));
					newgame();
				}	
				
				
			}
				
			);
			JMenuItem New4 = new JMenuItem("new 2 player 6*6 game");
			//add "new game" to the menu "file"
			file.add(New4);
			New4.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent arg0) {
					//n = 6;
					 m = 6;
					panel.setLayout(new GridLayout(m,m));
					newgame();
				}	
				
				
			}
				
			);
			
			JMenuItem New5 = new JMenuItem("new 1 player 3*3 game");
			//add "new game" to the menu "file"
			file.add(New5);
			New5.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent arg0) {
					//n = 3;
					 m = 3;
					panel.setLayout(new GridLayout(m,m));
					newgame1();
				}	
				
				
			}
				
			);
			JMenuItem New6 = new JMenuItem("new 1 player 4*4 game");
			//add "new game" to the menu "file"
			file.add(New6);
			New6.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent arg0) {
					//n = 3;
					 m = 4;
					panel.setLayout(new GridLayout(m,m));
					newgame1();
				}	
				
				
			}
				
			);
			
			JMenuItem New7 = new JMenuItem("new 1 player 5*5 game");
			//add "new game" to the menu "file"
			file.add(New7);
			New7.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent arg0) {
					//n = 3;
					 m = 5;
					panel.setLayout(new GridLayout(m,m));
					newgame1();
				}	
				
				
			}
				
			);
			
			JMenuItem New8 = new JMenuItem("new 1 player 6*6 game");
			//add "new game" to the menu "file"
			file.add(New8);
			New8.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent arg0) {
					//n = 3;
					 m = 6;
					panel.setLayout(new GridLayout(m,m));
					newgame1();
				}	
				
				
			}
				
			);
			
			JMenuItem quit = new JMenuItem("quit");
			file.add(quit);
			quit.addActionListener(new ActionListener()
			{
				public void actionPerformed(ActionEvent e) {
					mainframe.dispose();
				}	
				
				
			}
				
			);
			mbar.add(file);
			JMenu Rules = new JMenu("How To Play");
			JMenuItem rules = Rules.add("How To Play");
			mbar.add(Rules);
			rules.addActionListener(new ActionListener() {

				@Override
				public void actionPerformed(ActionEvent arg0) {
					JOptionPane.showMessageDialog(mainframe, howcan);
				}
			});
			
			
			//add the menu "file" to the menu bar
			
			
			// add the menu bar to the container
			mainpane.add(mbar,BorderLayout.PAGE_START);
			
			
			// Create status bar
			statuslabel = new JLabel("Start a new game");
			mainpane.add(statuslabel, BorderLayout.PAGE_END);
			
			//panel = new JPanel(new GridLayout(4,4));
			panel = new JPanel();
			panel.setCursor(new Cursor(12));// Displays a clickable cursor
			panel.setLayout(new GridLayout(m, m));

			mainframe.add(panel, BorderLayout.CENTER);

			mainframe.pack();
			mainframe.setVisible(true);

	}
	
	private void newgame()
	{
		
		final int n = m;
		flag=0;
		clicked = new int[m][m];
		panel.removeAll();
		int i,j;
		crossbuttons = new JButton[m][m];
		//final int n = tictac.n;
		statuslabel.setText("game has begun");
		//statuslabel.setAlignmentX(5);
		mainpane.add(statuslabel, BorderLayout.PAGE_END);
		turn = 1;
		num_clicked = 0;
		for(i=0;i<m;i++)
			for(j=0;j<m;j++)
				clicked[i][j]=0;
		for(i=0;i<m;i++)
		{	
			for(j=0;j<m;j++)
			{
				
				final int mi = i;
				final int mj = j;
				crossbuttons[i][j] = new JButton("");
				crossbuttons[i][j].setBackground(new Color(255, 255, 255));
				if(flag>0)
				{
					for(i=0;i<m;i++)
						for(j=0;j<m;j++)
							crossbuttons[i][j].setEnabled(false);
				}
				
				crossbuttons[i][j].addMouseListener( new MouseListener() {
					
					public void mouseClicked(MouseEvent e) {
						
						
						if ( e.getButton() == MouseEvent.BUTTON1 )
						{
							try {
								
								makemove(mi,mj,turn,n);
							} catch (IOException e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							}
							
							num_clicked++;
							if(num_clicked== (m*m) && flag==0)
								statuslabel.setText("game over,ends in a draw");
							if(turn==1)
							{
								turn++;
							}
							else
								turn--;
						
						}
					}
					
					
					@Override
					public void mouseEntered(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void mouseExited(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void mousePressed(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void mouseReleased(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}
				}
					
				);
				
				
				
				panel.add(crossbuttons[i][j]);
				
			}
		}
		mainpane.add(panel);
		
		mainframe.pack();
		mainframe.setVisible(true);
		
	}
	
	public void makemove(int i,int j, int turn,int n) throws IOException
	{
		if(flag!=0)
		{
			return ;
		}
		int k;
		//int n=m;
		BufferedImage XImage = ImageIO.read(new File("./x.png"));
		BufferedImage OImage = ImageIO.read(new File("./o.jpg"));
		
		
		if(turn==1)
		{
				
			if(flag==0)	
			crossbuttons[i][j].setIcon(new ImageIcon(XImage));
				crossbuttons[i][j].setBackground(new Color(255,255,255));
				
				clicked[i][j] = 1;
				//check win
				
		
		
		//check right
		
		int num=0;
		k=j;
		while(k<(j+n) && k<n && clicked[i][k]==1)
		{
			num++;
			
			crossbuttons[i][k].setBackground(new Color(200,150,100));
			k++;
		}
		k=j-1;
		while(k>(j-n) && k>=0 && clicked[i][k]==1)
		{
			num++;
			
			crossbuttons[i][k].setBackground(new Color(200,150,100));
		    k--;
		}
		if(num==n)
		{
			flag=1;//player 1 wins
			crossbuttons[i][j].setBackground(new Color(200,150,100));
		}
		else
		{
			k=j;
			while(k<(j+n) && k<n && clicked[i][k]==1)
			{
				num++;
				
				crossbuttons[i][k].setBackground(new Color(255,255,255));
				k++;
			}
			k=j-1;
			while(k>(j-n) && k>=0 && clicked[i][k]==1)
			{
				num++;
				
				crossbuttons[i][k].setBackground(new Color(255,255,255));
				k--;
			}
			
		}
		//check vertically
		
		num=0;
		k=i;
		while(k<(i+n) && k<n && clicked[k][j]==1)
		{
			num++;
			crossbuttons[k][j].setBackground(new Color(200,150,100));
			k++;
			
		
		}
		k=i-1;
		while(k>(i-n) && k>=0 && clicked[k][j]==1)
		{
			num++;
			crossbuttons[k][j].setBackground(new Color(200,150,100));
			k--;
			
		
		}
		if(num==n)
		{
			crossbuttons[i][j].setBackground(new Color(200,150,100));
			flag=1;//player 1 wins
		}
		
		else
		{
			k=i;
			while(k<(i+n) && k<n && clicked[k][j]==1)
			{
				num++;
				crossbuttons[k][j].setBackground(new Color(255,255,255));
				k++;
				
			
			}
			k=i-1;
			while(k>(i-n) && k>=0 && clicked[k][j]==1)
			{
				num++;
				crossbuttons[k][j].setBackground(new Color(255,255,255));
				k--;
				
			
			}	
			
		}
		
		//left up to right down
		num=0;
		k=i;
		int l = j;
		while(k<(i+n) && k<n &&l<n && clicked[k][l]==1)
		{
			num++;
			crossbuttons[k][l].setBackground(new Color(200,150,100));
			k++;
			l++;
			
		
		}
		k=i-1;
		l = j-1;
		while(k>(i-n) && k>=0 && l>=0 && clicked[k][l]==1)
		{
			num++;
			crossbuttons[k][l].setBackground(new Color(200,150,100));
			k--;
			l--;
		
		}
		if(num==n)
		{
			crossbuttons[i][j].setBackground(new Color(200,150,100));
			flag=1;//player 1 wins
		}
		else
		{
			k=i;
			l = j;
			while(k<(i+n) && k<n &&l<n && clicked[k][l]==1)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(255,255,255));
				k++;
				l++;
				
			
			}
			k=i-1;
			l = j-1;
			while(k>(i-n) && k>=0 && l>=0 && clicked[k][l]==1)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(255,255,255));
				k--;
				l--;
			
			}
			
			
		}
		//left down to right up
		num=0;
		k=i;
		l = j;
		while(k<(i+n) && k<n && l>=0 && clicked[k][l]==1)
		{
			num++;
			crossbuttons[k][l].setBackground(new Color(200,150,100));
			k++;
			l--;
			
		
		}
		k=i-1;
		l = j+1;
		while(k>(i-n) && k>=0 && l<n && clicked[k][l]==1)
		{
			num++;
			crossbuttons[k][l].setBackground(new Color(200,150,100));
			k--;
			l++;
		
		}
		if(num==n)
		{
			crossbuttons[i][j].setBackground(new Color(200,150,100));
			flag=1;//player 1 wins
		}
		else
		{
			k=i;
			l = j;
			while(k<(i+n) && k<n && l>=0 && clicked[k][l]==1)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(255,255,255));
				k++;
				l--;
				
			
			}
			k=i-1;
			l = j+1;
			while(k>(i-n) && k>=0 && l<n && clicked[k][l]==1)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(255,255,255));
				k--;
				l++;
			
			}	
			
		}
		if(flag==1)
		{
			player1++;
			statuslabel.setText("player1 wins and gets  " + player1 + "  points");
			crossbuttons[i][j].setBackground(new Color(200,150,100));
		}
		}
		else
		{
			//crossbuttons[i][j].setText("O");
			if(flag==0)
			crossbuttons[i][j].setIcon(new ImageIcon(OImage));
			clicked[i][j] = 2;
			crossbuttons[i][j].setBackground(new Color(255,255,255));
						//flag =1 if win
			//check right
			
			int num=0;
			k=j;
			while(k<(j+n) && k<n && clicked[i][k]==2)
			{
				num++;
				crossbuttons[i][k].setBackground(new Color(50,100,200));
				k++;
				
			
			}
			k=j-1;
			while(k>(j-n) && k>=0 && clicked[i][k]==2)
			{
				num++;
				crossbuttons[i][k].setBackground(new Color(50,100,200));
				k--;
				
			
			}
			if(num==n)
			{
				flag=2;//player 2 wins
			}
			else
			{
				k=j;
				while(k<(j+n) && k<n && clicked[i][k]==2)
				{
					num++;
					crossbuttons[i][k].setBackground(new Color(50,255,255));
					k++;
					
				
				}
				k=j-1;
				while(k>(j-n) && k>=0 && clicked[i][k]==2)
				{
					num++;
					crossbuttons[i][k].setBackground(new Color(255,255,255));
					k--;
					
				
				}
			}
			//check vertically
			
			num=0;
			k=i;
			while(k<(i+n) && k<n && clicked[k][j]==2)
			{
				num++;
				crossbuttons[k][j].setBackground(new Color(50,100,200));
				k++;
				
			
			}
			k=i-1;
			while(k>(i-n) && k>=0 && clicked[k][j]==2)
			{
				num++;
				crossbuttons[k][j].setBackground(new Color(50,100,200));
				k--;
				
			
			}
			if(num==n)
			{
				flag=2;//player 2 wins
			}
			
			else
			{
				k=i;
				while(k<(i+n) && k<n && clicked[k][j]==2)
				{
					num++;
					crossbuttons[k][j].setBackground(new Color(255,255,255));
					k++;
					
				
				}
				k=i-1;
				while(k>(i-n) && k>=0 && clicked[k][j]==2)
				{
					num++;
					crossbuttons[k][j].setBackground(new Color(255,255,255));
					k--;
					
				
				}	
				
			}
			//left up to right down
			
			num=0;
			k=i;
			int l = j;
			while(k<(i+n) && k<n &&l<n && clicked[k][l]==2)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(50,100,200));
				k++;
				l++;
				
			
			}
			k=i-1;
			l = j-1;
			while(k>(i-n) && k>=0 && l>=0 && clicked[k][l]==2)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(50,100,200));
				k--;
				l--;
			
			}
			if(num==n)
			{
				flag=2;//player 2 wins
			}
			else
			{
				k=i;
				l = j;
				while(k<(i+n) && k<n &&l<n && clicked[k][l]==2)
				{
					num++;
					crossbuttons[k][l].setBackground(new Color(255,255,255));
					k++;
					l++;
					
				
				}
				k=i-1;
				l = j-1;
				while(k>(i-n) && k>=0 && l>=0 && clicked[k][l]==2)
				{
					num++;
					crossbuttons[k][l].setBackground(new Color(255,255,255));
					k--;
					l--;
				
				}
				
				
			}
			//left down to right up
			num=0;
			k=i;
			l = j;
			while(k<(i+n) && k<n && l>=0 && clicked[k][l]==2)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(50,100,200));
				k++;
				l--;
				
			
			}
			k=i-1;
			l = j+1;
			while(k>(i-n) && k>=0 && l<n && clicked[k][l]==2)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(50,100,200));
				k--;
				l++;
			
			}
			if(num==n)
			{
				flag=2;//player 2 wins
			}
			else
			{
				k=i;
				l = j;
				while(k<(i+n) && k<n && l>=0 && clicked[k][l]==2)
				{
					num++;
					crossbuttons[k][l].setBackground(new Color(255,255,255));
					k++;
					l--;
					
				
				}
				k=i-1;
				l = j+1;
				while(k>(i-n) && k>=0 && l<n && clicked[k][l]==2)
				{
					num++;
					crossbuttons[k][l].setBackground(new Color(255,255,255));
					k--;
					l++;
				
				}
			
			}
			if(flag==2)
			{
				player2++;
				statuslabel.setText("player2 wins and gets " + player2 + "points");
				crossbuttons[i][j].setBackground(new Color(50,100,200));
			}
		
		
		
		
		
		
		
		
		
		}
		
	}
	
	private void newgame1()
	{
		
		final int n = m;
		flag=0;
		clicked = new int[m][m];
		panel.removeAll();
		int i,j;
		crossbuttons = new JButton[m][m];
		//final int n = tictac.n;
		statuslabel.setText("game has begun");
		//statuslabel.setAlignmentX(5);
		mainpane.add(statuslabel, BorderLayout.PAGE_END);
		
		num_clicked = 0;
		for(i=0;i<m;i++)
			for(j=0;j<m;j++)
				clicked[i][j]=0;
		for(i=0;i<m;i++)
		{	
			for(j=0;j<m;j++)
			{
				
				final int mi = i;
				final int mj = j;
				crossbuttons[i][j] = new JButton("");
				crossbuttons[i][j].setBackground(new Color(255, 255, 255));
				
				crossbuttons[i][j].addMouseListener( new MouseListener() {
					
					public void mouseClicked(MouseEvent e) {
						if ( e.getButton() == MouseEvent.BUTTON1 )
						{
							try {
								if(flag==0)
								{
								makemove1(mi,mj,n);
								lastposi = mi;
								lastposj = mj;
								System.out.println(mi + " hows going  " + mj);
								}
								} catch (IOException e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							}
							num_clicked++;
							num_clicked++;
							if(num_clicked >= (m*m) && flag==0)
								statuslabel.setText("game over,ends in a draw");
													
						}
					}
					
					
					@Override
					public void mouseEntered(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void mouseExited(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void mousePressed(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}

					@Override
					public void mouseReleased(MouseEvent e) {
						// TODO Auto-generated method stub
						
					}
				}
					
				);
				
				
				
				panel.add(crossbuttons[i][j]);
				
			}
		}
		mainpane.add(panel);
		
		mainframe.pack();
		mainframe.setVisible(true);
		
	}
	//makes player move and then computer move
	public void makemove1(int i,int j,int n) throws IOException
	{
		int k;
		//int n=m;
		BufferedImage XImage = ImageIO.read(new File("./x.png"));
		BufferedImage OImage = ImageIO.read(new File("./o.jpg"));
		
		if(flag==0)	
			crossbuttons[i][j].setIcon(new ImageIcon(XImage));
				crossbuttons[i][j].setBackground(new Color(255,255,255));
				
				clicked[i][j] = 1;
				//check win
				
		
		
		//check right
		
		int num=0;
		k=j;
		while(k<(j+n) && k<n && clicked[i][k]==1)
		{
			num++;
			
			crossbuttons[i][k].setBackground(new Color(200,150,100));
			k++;
		}
		k=j-1;
		while(k>(j-n) && k>=0 && clicked[i][k]==1)
		{
			num++;
			
			crossbuttons[i][k].setBackground(new Color(200,150,100));
		    k--;
		}
		if(num==n)
		{
			flag=1;//player 1 wins
			crossbuttons[i][j].setBackground(new Color(200,150,100));
		}
		else
		{
			k=j;
			while(k<(j+n) && k<n && clicked[i][k]==1)
			{
				num++;
				
				crossbuttons[i][k].setBackground(new Color(255,255,255));
				k++;
			}
			k=j-1;
			while(k>(j-n) && k>=0 && clicked[i][k]==1)
			{
				num++;
				
				crossbuttons[i][k].setBackground(new Color(255,255,255));
				k--;
			}
			
		}
		//check vertically
		
		num=0;
		k=i;
		while(k<(i+n) && k<n && clicked[k][j]==1)
		{
			num++;
			crossbuttons[k][j].setBackground(new Color(200,150,100));
			k++;
			
		
		}
		k=i-1;
		while(k>(i-n) && k>=0 && clicked[k][j]==1)
		{
			num++;
			crossbuttons[k][j].setBackground(new Color(200,150,100));
			k--;
			
		
		}
		if(num==n)
		{
			crossbuttons[i][j].setBackground(new Color(200,150,100));
			flag=1;//player 1 wins
		}
		
		else
		{
			k=i;
			while(k<(i+n) && k<n && clicked[k][j]==1)
			{
				num++;
				crossbuttons[k][j].setBackground(new Color(255,255,255));
				k++;
				
			
			}
			k=i-1;
			while(k>(i-n) && k>=0 && clicked[k][j]==1)
			{
				num++;
				crossbuttons[k][j].setBackground(new Color(255,255,255));
				k--;
				
			
			}	
			
		}
		
		//left up to right down
		num=0;
		k=i;
		int l = j;
		while(k<(i+n) && k<n &&l<n && clicked[k][l]==1)
		{
			num++;
			crossbuttons[k][l].setBackground(new Color(200,150,100));
			k++;
			l++;
			
		
		}
		k=i-1;
		l = j-1;
		while(k>(i-n) && k>=0 && l>=0 && clicked[k][l]==1)
		{
			num++;
			crossbuttons[k][l].setBackground(new Color(200,150,100));
			k--;
			l--;
		
		}
		if(num==n)
		{
			crossbuttons[i][j].setBackground(new Color(200,150,100));
			flag=1;//player 1 wins
		}
		else
		{
			k=i;
			l = j;
			while(k<(i+n) && k<n &&l<n && clicked[k][l]==1)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(255,255,255));
				k++;
				l++;
				
			
			}
			k=i-1;
			l = j-1;
			while(k>(i-n) && k>=0 && l>=0 && clicked[k][l]==1)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(255,255,255));
				k--;
				l--;
			
			}
			
			
		}
		//left down to right up
		num=0;
		k=i;
		l = j;
		while(k<(i+n) && k<n && l>=0 && clicked[k][l]==1)
		{
			num++;
			crossbuttons[k][l].setBackground(new Color(200,150,100));
			k++;
			l--;
			
		
		}
		k=i-1;
		l = j+1;
		while(k>(i-n) && k>=0 && l<n && clicked[k][l]==1)
		{
			num++;
			crossbuttons[k][l].setBackground(new Color(200,150,100));
			k--;
			l++;
		
		}
		if(num==n)
		{
			crossbuttons[i][j].setBackground(new Color(200,150,100));
			flag=1;//player 1 wins
		}
		else
		{
			k=i;
			l = j;
			while(k<(i+n) && k<n && l>=0 && clicked[k][l]==1)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(255,255,255));
				k++;
				l--;
				
			
			}
			k=i-1;
			l = j+1;
			while(k>(i-n) && k>=0 && l<n && clicked[k][l]==1)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(255,255,255));
				k--;
				l++;
			
			}	
			
		}
		if(flag==1)
		{
			player1++;
			statuslabel.setText("player1 wins and gets  " + player1 + "  points");
			crossbuttons[i][j].setBackground(new Color(200,150,100));
		}	
				
		if(num_clicked <((m*m)-1))
		{
		Random rand = new Random();

		// make random move for comp
		System.out.println(lastposi + "hey" + lastposj);
		i = (lastposi +1)%m;
		j = (lastposj)%m;
		if(clicked[i][j]!=0)
		{
			
			i = (lastposi)%m;
			j = (lastposj+1)%m;
		}
		
		if(clicked[i][j]!=0)
		{
			
			i = (lastposi+1)%m;
			j = (lastposj+1)%m;
		}
		
		while(clicked[i][j]!=0)
		{
			
			i = rand.nextInt(m)%m;
			j = rand.nextInt(m)%m;
		}
		
		
		// i,j is the move
		
			//crossbuttons[i][j].setText("O");
		if(flag==0)
			crossbuttons[i][j].setIcon(new ImageIcon(OImage));
			clicked[i][j] = 2;
			crossbuttons[i][j].setBackground(new Color(255,255,255));
						//flag =1 if win
			//check right
			
			 num=0;
			k=j;
			while(k<(j+n) && k<n && clicked[i][k]==2)
			{
				num++;
				crossbuttons[i][k].setBackground(new Color(50,100,200));
				k++;
				
			
			}
			k=j-1;
			while(k>(j-n) && k>=0 && clicked[i][k]==2)
			{
				num++;
				crossbuttons[i][k].setBackground(new Color(50,100,200));
				k--;
				
			
			}
			if(num==n)
			{
				flag=2;//player 2 wins
			}
			else
			{
				k=j;
				while(k<(j+n) && k<n && clicked[i][k]==2)
				{
					num++;
					crossbuttons[i][k].setBackground(new Color(50,255,255));
					k++;
					
				
				}
				k=j-1;
				while(k>(j-n) && k>=0 && clicked[i][k]==2)
				{
					num++;
					crossbuttons[i][k].setBackground(new Color(255,255,255));
					k--;
					
				
				}
			}
			//check vertically
			
			num=0;
			k=i;
			while(k<(i+n) && k<n && clicked[k][j]==2)
			{
				num++;
				crossbuttons[k][j].setBackground(new Color(50,100,200));
				k++;
				
			
			}
			k=i-1;
			while(k>(i-n) && k>=0 && clicked[k][j]==2)
			{
				num++;
				crossbuttons[k][j].setBackground(new Color(50,100,200));
				k--;
				
			
			}
			if(num==n)
			{
				flag=2;//player 2 wins
			}
			
			else
			{
				k=i;
				while(k<(i+n) && k<n && clicked[k][j]==2)
				{
					num++;
					crossbuttons[k][j].setBackground(new Color(255,255,255));
					k++;
					
				
				}
				k=i-1;
				while(k>(i-n) && k>=0 && clicked[k][j]==2)
				{
					num++;
					crossbuttons[k][j].setBackground(new Color(255,255,255));
					k--;
					
				
				}	
				
			}
			//left up to right down
			
			num=0;
			k=i;
			 l = j;
			while(k<(i+n) && k<n &&l<n && clicked[k][l]==2)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(50,100,200));
				k++;
				l++;
				
			
			}
			k=i-1;
			l = j-1;
			while(k>(i-n) && k>=0 && l>=0 && clicked[k][l]==2)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(50,100,200));
				k--;
				l--;
			
			}
			if(num==n)
			{
				flag=2;//player 2 wins
			}
			else
			{
				k=i;
				l = j;
				while(k<(i+n) && k<n &&l<n && clicked[k][l]==2)
				{
					num++;
					crossbuttons[k][l].setBackground(new Color(255,255,255));
					k++;
					l++;
					
				
				}
				k=i-1;
				l = j-1;
				while(k>(i-n) && k>=0 && l>=0 && clicked[k][l]==2)
				{
					num++;
					crossbuttons[k][l].setBackground(new Color(255,255,255));
					k--;
					l--;
				
				}
				
				
			}
			//left down to right up
			num=0;
			k=i;
			l = j;
			while(k<(i+n) && k<n && l>=0 && clicked[k][l]==2)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(50,100,200));
				k++;
				l--;
				
			
			}
			k=i-1;
			l = j+1;
			while(k>(i-n) && k>=0 && l<n && clicked[k][l]==2)
			{
				num++;
				crossbuttons[k][l].setBackground(new Color(50,100,200));
				k--;
				l++;
			
			}
			if(num==n)
			{
				flag=2;//player 2 wins
			}
			else
			{
				k=i;
				l = j;
				while(k<(i+n) && k<n && l>=0 && clicked[k][l]==2)
				{
					num++;
					crossbuttons[k][l].setBackground(new Color(255,255,255));
					k++;
					l--;
					
				
				}
				k=i-1;
				l = j+1;
				while(k>(i-n) && k>=0 && l<n && clicked[k][l]==2)
				{
					num++;
					crossbuttons[k][l].setBackground(new Color(255,255,255));
					k--;
					l++;
				
				}
			
			}
			
			if(flag==2)
			{
				comp++;
				statuslabel.setText("computer wins and gets " + comp + "points");
				crossbuttons[i][j].setBackground(new Color(50,100,200));
			}
		
		
		
		}
		
		
		
		
		
		
		
	}
}
