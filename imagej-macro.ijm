// This code is written by Hiroshi Ochiai @ Hiroshima University. (ochiai@hiroshima-u.ac.jp)
	
//-------------------------
// The following parameters should be changed depending on the imaging conditions.
bg_value = 500; // This is the value for background correction. This value (500) needs to be changed depending on the microscope used. It should be about the same as the average background fluorescence intensity of a place where no cells and debris are contained after the imaging conditions are fixed.
pixel_x = 0.13; // Enter the length in the x-axis per pixel.
pixel_y = 0.13; // Enter the length in the y-axis per pixel.
//-------------------------




run("Synchronize Windows");

/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".nd2") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
		
	run("Bio-Formats", "open="+ input + File.separator + file +" color_mode=Grayscale rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	
	rename("stack"); // Importing Images.
	
	run("Properties...", "channels=3 slices=1 frames=10 pixel_width="+pixel_x+" pixel_height="+pixel_y+" voxel_depth=1.0000000 frame=[0.00 sec]"); // Change the image properties. The pixel width setting and the order of the images are changed. The acquired image stack is a three-color time-lapse image, but here it is recognized as a three-color z-stack image. This enables the average projection of the image at a later step. 
	run("Gaussian Blur...", "sigma=1 stack"); // Apply a Gaussian blur filter.
	run("Split Channels"); // Separate the image stack into channels.
	selectWindow("C1-stack"); // Select an image for the first color (SNAPtag channel).
	run("Bleach Correction", "correction=[Simple Ratio] background="+ bg_value+""); // Correct photobleaching.
	run("Subtract Background...", "rolling=50 stack"); // Correct uneven illumination.
	selectWindow("C1-stack"); close(); // Delete the pre-processed image.
	selectWindow("C2-stack"); // Select an image for the second channel (RFP channel).
	
	run("Bleach Correction", "correction=[Simple Ratio] background="+ bg_value
	+""); // Correct photobleaching.
	run("Subtract Background...", "rolling=50 stack"); // Correct for uneven illumination.
	run("Subtract Background...", "rolling=5 stack"); // Emphasize spots.
	selectWindow("C2-stack"); close(); // Delete the pre-processed image.
	selectWindow("C3-stack"); // Select an image for the third channel (mNG channel).
	run("Bleach Correction", "correction=[Simple Ratio] background="+ bg_value +""); // Correct photobleaching.
	run("Subtract Background...", "rolling=50 stack"); // Correct for uneven illumination.
	run("Subtract Background...", "rolling=5 stack"); // Emphasize spots.
	selectWindow("C3-stack"); close(); // Delete the pre-processed image.
	run("Merge Channels...", "c1=DUP_C1-stack c2=DUP_C2-stack c3=DUP_C3-stack create ignore"); // Merge the processed three-color stacks.
	Stack.setDisplayMode("grayscale");
	Stack.setChannel(3);
	run("Set... ", "zoom=150");
	
	run("Z Project...", "projection=[Average Intensity]"); // Average intensity projection
	Stack.setDisplayMode("grayscale");
	Stack.setChannel(3);
	run("Set... ", "zoom=150");
	//close("Composite"); 
	//close("Merged"); // Delete the unwanted images.
	rename("Stack"); // Rename the image.
	
	if (roiManager("Count") > 0){
		roiManager("Deselect");
		roiManager("Delete");// Deletes all ROIs
	}
	
	run("Point Tool...", "type=Hybrid color=Blue size=Small add label show");
	
	selectWindow("Merged");
	run("Animation Options...", "speed=20");
	run("Start Animation");
	
	//run("Synchronize Windows");
	selectWindow("Stack");
	setTool("point");
	run("Brightness/Contrast...");
	waitForUser("Select mTetR signals."); 
	
	if (roiManager("Count") > 0){
		roiManager("Deselect");
		roiManager("Save", output+ File.separator + file+".zip");	
	}
	
	close("*");
}
