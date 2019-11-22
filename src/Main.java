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

		writer.write("gridSize(" + gridSize[0] + "," + gridSize[1] + ").");
		writer.write('\n');
		writer.write("iAt(" + ironmanPos[0] + "," + ironmanPos[1] + ",s0" + ").");
		writer.write('\n');
		writer.write("tAt(" + thanosPos[0] + "," + thanosPos[1] + ").");
		writer.write('\n');
		
		for(int i = 1; i <= 4; i++) {
			writer.write("sAt(" + i + "," + stonesPos[(i-1)*2] + "," + stonesPos[(i*2)-1] + "," + 0 + ",s0" + ").");
			writer.write('\n');
		}
		
		writer.close();
	}
	
	public static void main(String[] args) throws IOException {
		GenGrid("5,5;1,2;3,4;1,1,2,1,2,2,3,3");		// The example grid from project PDF
		GenGrid("5,5;2,2;4,2;4,0,1,2,3,0,2,1");		// The first test grid from last project unit tests
	}

}
