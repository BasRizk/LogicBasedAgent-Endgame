import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class Main {
	
	private static int KBCount = 1;
	
	public static void GenGrid(String grid) throws IOException {
		File file = new File("KB" + KBCount + ".pl"); KBCount++;
		BufferedWriter writer = new BufferedWriter(new FileWriter(file));
		
		String[] sections = grid.split(";");
		
		String[] gridSize = sections[0].split(",");
		String[] ironmanPos = sections[1].split(",");
		String[] thanosPos = sections[2].split(",");
		String[] stonesPos = sections[3].split(",");

		// gridSize(X,Y) axiom of grid with height X and width Y.
		writer.write("gridSize(" + gridSize[0] + "," + gridSize[1] + ").");
		writer.write('\n');
		// tAt(X,Y) axiom of Thanos position at height position X and width position Y.
		writer.write("tAt(" + thanosPos[0] + "," + thanosPos[1] + ").");
		writer.write('\n');
		
		// write axioms for the four stones.
		for(int i = 1; i <= 4; i++) {
			// sAt(ID,X,Y,S) axiom of stone existance at height position X and width position Y
			// at s0: the initial state. ID is just an ID for each stone
			writer.write("sAt(" + i + "," + stonesPos[(i-1)*2] + "," + stonesPos[(i*2)-1] + ",s0" + ").");
			writer.write('\n');
		}

		// iAt(X,Y,S) axiom of Ironman position at height position X and width position Y in state S. s0 is the initial state.
		writer.write("iAt(" + ironmanPos[0] + "," + ironmanPos[1] + ",s0" + ").");
		writer.write('\n');		
		
		writer.close();
	}
	
	public static void main(String[] args) throws IOException {
		GenGrid("5,5;1,2;3,4;1,1,2,1,2,2,3,3");		// The example grid from project PDF
		GenGrid("5,5;2,2;4,2;4,0,1,2,3,0,2,1");		// The first test grid from last project unit tests
	}

}
