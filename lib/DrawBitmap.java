private Bitmap drawBasic(Bitmap src) {
        Bitmap dst = src.copy(Bitmap.Config.ARGB_8888,true);
        Paint DotYellow = newPaintLine("#dfe734",4f, Paint.Style.FILL);
        Paint SolidLineRed = newPaintLine("#ff0000",(float)FaceWidth/200, Paint.Style.STROKE);
        Paint SolidLineOrange = newPaintLine("#f36523",(float)FaceWidth/200,Paint.Style.STROKE);
        Paint SolidLineGreen = newPaintLine("#0ed145",(float)FaceWidth/200,Paint.Style.STROKE);
        Paint SolidLineMarineBlue = newPaintLine("#252162",(float)FaceWidth/125,Paint.Style.STROKE);
        Paint DotLineOrange = newDotPaint("#f36523",(float)FaceWidth/200,15f,10f,Paint.Style.STROKE);
        Paint DotLineDeepBlue = newDotPaint("#3f48cc",(float)FaceWidth/125,25f,25f,Paint.Style.STROKE);
        Paint DotWhite = newPaintLine("#FFFFFF",8f, Paint.Style.FILL);
        Paint SolidLineWhite = newPaintLine("#FFFFFF",(float)FaceWidth/200, Paint.Style.STROKE);
        Paint WordBlue = newWordPaint("#00ddff",FaceWidth/15);
        float DotSize = (float)FaceWidth/50;
        float DotSizeSmall = DotSize / 3;
        float DotSizeSmaller = DotSize / (float)1.5;

        Canvas canvas = new Canvas(dst);

        // 122個座標點
        for (int i = 0; i < 148; ++i) {
            canvas.drawCircle(allPoint[i].x,allPoint[i].y,DotSizeSmall,DotYellow);
        }

        // 五眼箭頭水平線，需要額外寫Function來畫三角形，java不支援頭尾自動生成箭頭
//        int Top = (FaceLowPoint.y - EyeRightRightPoint.y) / 2;
        int stopY = EyebrowRightRightPoint.y - (FaceLowPoint.y - EyeRightRightPoint.y) / 2;
        drawTria(canvas, FaceRightPoint.x, stopY, EyeRightRightPoint.x, stopY, (int)DotSize, (int)DotSize, SolidLineRed, SolidLineRed);
        drawTria(canvas, EyeRightRightPoint.x, stopY, EyeRightLeftPoint.x, stopY, (int)DotSize, (int)DotSize, SolidLineRed, SolidLineRed);
        drawTria(canvas, EyeRightLeftPoint.x, stopY, EyeLeftRightPoint.x, stopY, (int)DotSize, (int)DotSize, SolidLineRed, SolidLineRed);
        drawTria(canvas, EyeLeftRightPoint.x, stopY, EyeLeftLeftPoint.x, stopY, (int)DotSize, (int)DotSize, SolidLineRed, SolidLineRed);
        drawTria(canvas, EyeLeftLeftPoint.x, stopY, FaceLeftPoint.x, stopY, (int)DotSize, (int)DotSize, SolidLineRed, SolidLineRed);
        // 五眼垂直線
        canvas.drawLine(FaceRightPoint.x, stopY, FaceRightPoint.x, stopY + FaceHeight/20, SolidLineRed);
        canvas.drawLine(EyeRightRightPoint.x, stopY, EyeRightRightPoint.x, stopY + FaceHeight/20, SolidLineRed);
        canvas.drawLine(EyeRightLeftPoint.x, stopY, EyeRightLeftPoint.x, stopY + FaceHeight/20, SolidLineRed);
        canvas.drawLine(EyeLeftRightPoint.x, stopY, EyeLeftRightPoint.x, stopY + FaceHeight/20, SolidLineRed);
        canvas.drawLine(EyeLeftLeftPoint.x, stopY, EyeLeftLeftPoint.x, stopY + FaceHeight/20, SolidLineRed);
        canvas.drawLine(FaceLeftPoint.x, stopY, FaceLeftPoint.x, stopY + FaceHeight/20, SolidLineRed);
        // 五眼比例
        canvas.drawText(((int) FiveEyeRightEyeOuter) + "%", (FaceRightPoint.x + EyeRightRightPoint.x) / 2, EyeRightRightPoint.y - ((FaceLowPoint.y - EyeRightRightPoint.y) / 1.5F), WordBlue);
        canvas.drawText(((int) FiveEyeRightEyeInner) + "%", (EyeRightRightPoint.x + EyeRightLeftPoint.x) / 2, EyeRightRightPoint.y - ((FaceLowPoint.y - EyeRightRightPoint.y) / 1.5F), WordBlue);
        canvas.drawText(((int) FiveEyeCenter) + "%", (EyeRightLeftPoint.x + EyeLeftRightPoint.x) / 2, EyeRightRightPoint.y - ((FaceLowPoint.y - EyeRightRightPoint.y) / 1.5F), WordBlue);
        canvas.drawText(((int) FiveEyeLeftEyeInner) + "%", (EyeLeftRightPoint.x + EyeLeftLeftPoint.x) / 2, EyeRightRightPoint.y - ((FaceLowPoint.y - EyeRightRightPoint.y) / 1.5F), WordBlue);
        canvas.drawText(((int) FiveEyeLeftEyeOuter) + "%", (EyeLeftLeftPoint.x + FaceLeftPoint.x) / 2, EyeRightRightPoint.y - ((FaceLowPoint.y - EyeRightRightPoint.y) / 1.5F), WordBlue);
        // 鼻子寬度
        drawTria(canvas, NoseLeftPoint.x, NoseLeftPoint.y, NoseRightPoint.x, NoseRightPoint.y, (int)DotSize, (int)DotSize, SolidLineRed, SolidLineRed);
        canvas.drawText(Math.round(((double) NoseWidth / (EyeRightLeftPoint.x - EyeLeftRightPoint.x)) * 100) + "%", (NoseLeftPoint.x + NoseRightPoint.x) / 2, NoseLeftPoint.y, WordBlue);
        // 三庭水平線
        canvas.drawLine(FaceRightPoint.x, FaceTopPoint.y, (float) (FaceRightPoint.x + FaceWidth / 10), FaceTopPoint.y, SolidLineGreen);
        canvas.drawLine(FaceRightPoint.x, EyebrowRightDownPoint.y, (float) (FaceRightPoint.x + FaceWidth / 10), EyebrowRightDownPoint.y, SolidLineGreen);
        canvas.drawLine(FaceRightPoint.x, NoseLowPoint.y, (float) (FaceRightPoint.x + FaceWidth / 10), NoseLowPoint.y, SolidLineGreen);
        canvas.drawLine(FaceRightPoint.x, FaceLowPoint.y, (float) (FaceRightPoint.x + FaceWidth / 10), FaceLowPoint.y, SolidLineGreen);
        // 三庭箭頭垂直線
        drawTria(canvas, (float) (FaceRightPoint.x + FaceWidth / 10), FaceTopPoint.y, (float) (FaceRightPoint.x + FaceWidth / 10), EyebrowRightDownPoint.y, (int)DotSize, (int)DotSize, SolidLineGreen, SolidLineGreen);
        drawTria(canvas, (float) (FaceRightPoint.x + FaceWidth / 10), EyebrowRightDownPoint.y, (float) (FaceRightPoint.x + FaceWidth / 10), NoseLowPoint.y, (int)DotSize, (int)DotSize, SolidLineGreen, SolidLineGreen);
        drawTria(canvas, (float) (FaceRightPoint.x + FaceWidth / 10), NoseLowPoint.y, (float) (FaceRightPoint.x + FaceWidth / 10), FaceLowPoint.y, (int)DotSize, (int)DotSize, SolidLineGreen, SolidLineGreen);
        // 三庭比例
        canvas.drawText((int) ThreeCourtTop + "%", (float) (FaceRightPoint.x + FaceWidth / 12), (FaceTopPoint.y + EyebrowRightDownPoint.y) / 2, WordBlue);
        canvas.drawText((int) ThreeCourtCenter + "%", (float) (FaceRightPoint.x + FaceWidth / 12), (EyebrowRightDownPoint.y + NoseLowPoint.y) / 2, WordBlue);
        canvas.drawText((int) ThreeCourtLow + "%", (float) (FaceRightPoint.x + FaceWidth / 12), (NoseLowPoint.y + FaceLowPoint.y) / 2, WordBlue);
        // 嘴唇寬度
        canvas.drawText(Math.round(((double) MouthWidth / (EyeRightLeftPoint.x - EyeLeftRightPoint.x)) * 100) + "%", (MouthLeftPoint.x + MouthRightPoint.x) / 2, MouthLeftPoint.y, WordBlue);
        // 圖右臉部斜率 27 29
        Point pointOne;
        Point pointTwo;
        int theLen = FaceWidth*3/10;
        double ratio = ((double)(allPoint[39].y - allPoint[41].y)/(allPoint[39].x - allPoint[41].x));
        double degree = Math.atan(ratio);
        Point mid = new Point((allPoint[39].x+allPoint[41].x)/2,(allPoint[39].y+allPoint[41].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,DotLineDeepBlue);
        // 圖右下巴斜率 30 32
        ratio = ((double)(allPoint[42].y - allPoint[44].y)/(allPoint[42].x - allPoint[44].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[42].x+allPoint[44].x)/2,(allPoint[42].y+allPoint[44].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,DotLineDeepBlue);
        // 圖左下巴斜率 78 100
        ratio = ((double)(allPoint[90].y - allPoint[112].y)/(allPoint[90].x - allPoint[112].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[90].x+allPoint[112].x)/2,(allPoint[90].y+allPoint[112].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,DotLineDeepBlue);
        // 圖左臉部斜率 45 67
        ratio = ((double)(allPoint[57].y - allPoint[79].y)/(allPoint[57].x - allPoint[79].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[57].x+allPoint[79].x)/2,(allPoint[57].y+allPoint[79].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,DotLineDeepBlue);
        // 左眉毛直線 33-36-38
        canvas.drawLine(allPoint[45].x,allPoint[45].y,allPoint[48].x,allPoint[48].y,SolidLineOrange);
        canvas.drawLine(allPoint[48].x,allPoint[48].y,allPoint[50].x,allPoint[50].y,SolidLineOrange);
        // 左眉毛直線 33-40-38
        canvas.drawLine(allPoint[45].x,allPoint[45].y,allPoint[52].x,allPoint[52].y,SolidLineOrange);
        canvas.drawLine(allPoint[52].x,allPoint[52].y,allPoint[50].x,allPoint[50].y,SolidLineOrange);
        // 右眉毛直線 42-44-47
        canvas.drawLine(allPoint[54].x,allPoint[54].y,allPoint[56].x,allPoint[56].y,SolidLineOrange);
        canvas.drawLine(allPoint[56].x,allPoint[56].y,allPoint[59].x,allPoint[59].y,SolidLineOrange);
        // 右眉毛直線 42-49-47
        canvas.drawLine(allPoint[54].x,allPoint[54].y,allPoint[61].x,allPoint[61].y,SolidLineOrange);
        canvas.drawLine(allPoint[61].x,allPoint[61].y,allPoint[59].x,allPoint[59].y,SolidLineOrange);
        // 眉毛水平直線 36 & 40 & 44 & 49
        canvas.drawLine(allPoint[48].x,allPoint[48].y,(allPoint[50].x+allPoint[63].x)/2,allPoint[48].y,SolidLineMarineBlue);
        canvas.drawLine(allPoint[52].x,allPoint[52].y,(allPoint[50].x+allPoint[63].x)/2,allPoint[52].y,SolidLineMarineBlue);
        canvas.drawLine(allPoint[56].x,allPoint[56].y,allPoint[15].x,allPoint[56].y,SolidLineMarineBlue);
        canvas.drawLine(allPoint[61].x,allPoint[61].y,allPoint[15].x,allPoint[61].y,SolidLineMarineBlue);
        // 眉毛端點垂直線 62 & 66 & 71 & 75
        canvas.drawLine(allPoint[74].x,allPoint[74].y - FaceHeight/15,allPoint[74].x,allPoint[74].y + FaceHeight/15,SolidLineGreen);
        canvas.drawLine(allPoint[78].x,allPoint[78].y - FaceHeight/15,allPoint[78].x,allPoint[78].y + FaceHeight/15,SolidLineGreen);
        canvas.drawLine(allPoint[83].x,allPoint[83].y - FaceHeight/15,allPoint[83].x,allPoint[83].y + FaceHeight/15,SolidLineGreen);
        canvas.drawLine(allPoint[87].x,allPoint[87].y - FaceHeight/15,allPoint[87].x,allPoint[87].y + FaceHeight/15,SolidLineGreen);
        // 左眼三角形 62-64-66
        canvas.drawLine(allPoint[74].x,allPoint[74].y,allPoint[76].x,allPoint[76].y,SolidLineOrange);
        canvas.drawLine(allPoint[76].x,allPoint[76].y,allPoint[78].x,allPoint[78].y,SolidLineOrange);
        canvas.drawLine(allPoint[74].x,allPoint[74].y,allPoint[78].x,allPoint[78].y,SolidLineRed);
        // 右眼三角形 71-73-75
        canvas.drawLine(allPoint[83].x,allPoint[83].y,allPoint[85].x,allPoint[85].y,SolidLineOrange);
        canvas.drawLine(allPoint[85].x,allPoint[85].y,allPoint[87].x,allPoint[87].y,SolidLineOrange);
        canvas.drawLine(allPoint[83].x,allPoint[83].y,allPoint[87].x,allPoint[87].y,SolidLineRed);
        // 左眼矩形(上下左右) 64-69-62-66
        canvas.drawLine(allPoint[74].x,allPoint[76].y,allPoint[74].x,allPoint[81].y,SolidLineGreen);
        canvas.drawLine(allPoint[78].x,allPoint[76].y,allPoint[78].x,allPoint[66].y,SolidLineGreen);
        canvas.drawLine(allPoint[74].x,allPoint[76].y,allPoint[78].x,allPoint[76].y,SolidLineMarineBlue);
        canvas.drawLine(allPoint[74].x,allPoint[81].y,allPoint[78].x,allPoint[81].y,SolidLineMarineBlue);
        // 右眼矩形(上下左右) 73-77-71-75
        canvas.drawLine(allPoint[83].x,allPoint[85].y,allPoint[83].x,allPoint[89].y,SolidLineGreen);
        canvas.drawLine(allPoint[87].x,allPoint[85].y,allPoint[87].x,allPoint[89].y,SolidLineGreen);
        canvas.drawLine(allPoint[83].x,allPoint[85].y,allPoint[87].x,allPoint[85].y,SolidLineMarineBlue);
        canvas.drawLine(allPoint[83].x,allPoint[89].y,allPoint[87].x,allPoint[89].y,SolidLineMarineBlue);
        // 鼻子左右垂直線 57 & 60
        canvas.drawLine(allPoint[69].x,allPoint[69].y - FaceHeight/15,allPoint[69].x,allPoint[69].y + FaceHeight/15,SolidLineMarineBlue);
        canvas.drawLine(allPoint[72].x,allPoint[72].y - FaceHeight/15,allPoint[72].x,allPoint[72].y + FaceHeight/15,SolidLineMarineBlue);
        // 嘴唇左右垂直線 80 & 86
        canvas.drawLine(allPoint[92].x,allPoint[92].y - FaceHeight/15,allPoint[92].x,allPoint[92].y + FaceHeight/15,SolidLineMarineBlue);
        canvas.drawLine(allPoint[98].x,allPoint[98].y - FaceHeight/15,allPoint[98].x,allPoint[98].y + FaceHeight/15,SolidLineMarineBlue);
        // 嘴唇上中下水平線 83 & 97 & 90
        canvas.drawLine(allPoint[92].x,allPoint[95].y,allPoint[98].x,allPoint[95].y,DotLineOrange);
        canvas.drawLine(allPoint[92].x,allPoint[109].y,allPoint[98].x,allPoint[109].y,DotLineOrange);
        canvas.drawLine(allPoint[92].x,allPoint[102].y,allPoint[98].x,allPoint[102].y,DotLineOrange);
        // 額頭夾角 10-113-14
        canvas.drawLine(allPoint[10].x,allPoint[10].y,allPoint[125].x,allPoint[125].y,SolidLineGreen);
        canvas.drawLine(allPoint[125].x,allPoint[125].y,allPoint[14].x,allPoint[14].y,SolidLineGreen);
        // 額頭高度水平線 113 & 44 & 111
        canvas.drawLine(allPoint[125].x,allPoint[125].y,allPoint[24].x,allPoint[125].y,SolidLineRed);
        canvas.drawLine(allPoint[56].x,allPoint[56].y,allPoint[24].x,allPoint[56].y,SolidLineRed);
        canvas.drawLine(allPoint[123].x,allPoint[123].y,allPoint[24].x,allPoint[123].y,SolidLineRed);
        // 眉毛寬度 66 & 59.x & 71
        canvas.drawLine(allPoint[78].x,allPoint[78].y - FaceHeight/20,allPoint[78].x,allPoint[78].y + FaceHeight/20,SolidLineRed);
        canvas.drawLine(allPoint[71].x,allPoint[78].y - FaceHeight/20,allPoint[71].x,allPoint[78].y + FaceHeight/20,SolidLineRed);
        canvas.drawLine(allPoint[83].x,allPoint[78].y - FaceHeight/20,allPoint[83].x,allPoint[78].y + FaceHeight/20,SolidLineRed);
        canvas.drawLine(allPoint[78].x,allPoint[78].y,allPoint[83].x,allPoint[83].y,SolidLineRed);
        // 眉毛-內眼角 42-71 & 38-66
        canvas.drawLine(allPoint[54].x,allPoint[54].y,allPoint[83].x,allPoint[83].y + FaceHeight/20,SolidLineMarineBlue);
        canvas.drawLine(allPoint[50].x,allPoint[50].y,allPoint[78].x,allPoint[78].y + FaceHeight/20,SolidLineMarineBlue);
        // 外眼角垂直線(過眉毛) 62 & 75  ~ 110.y
        canvas.drawLine(allPoint[74].x,allPoint[74].y,allPoint[74].x,allPoint[122].y,SolidLineMarineBlue);
        canvas.drawLine(allPoint[87].x,allPoint[87].y,allPoint[87].x,allPoint[122].y,SolidLineMarineBlue);
        // 眉毛高低差 38 42
        canvas.drawLine(allPoint[50].x,allPoint[50].y,allPoint[54].x,allPoint[50].y,SolidLineGreen);
        canvas.drawLine(allPoint[50].x,allPoint[54].y,allPoint[54].x,allPoint[54].y,SolidLineGreen);
        canvas.drawLine((allPoint[50].x+allPoint[54].x)/2,allPoint[50].y,(allPoint[50].x+allPoint[54].x)/2,allPoint[54].y,SolidLineGreen);
        // 鼻尖耳垂高低水平線 59 104
        canvas.drawLine(allPoint[71].x,allPoint[71].y,allPoint[116].x - FaceWidth/15,allPoint[71].y,SolidLineRed);
        canvas.drawLine(allPoint[116].x,allPoint[116].y,allPoint[116].x - FaceWidth/15,allPoint[116].y,SolidLineRed);
        // 鼻子上下緣 59 51
        canvas.drawLine(allPoint[71].x - FaceWidth/5,allPoint[71].y,allPoint[71].x + FaceWidth/5,allPoint[71].y,SolidLineOrange);
        canvas.drawLine(allPoint[63].x - FaceWidth/5,allPoint[63].y,allPoint[63].x + FaceWidth/5,allPoint[63].y,SolidLineOrange);
        // 嘴唇角度 83 84
        ratio = ((double)(allPoint[95].y - allPoint[96].y)/(allPoint[95].x - allPoint[96].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[95].x+allPoint[96].x)/2,(allPoint[95].y+allPoint[96].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*FaceHeight/5),(int)(mid.y + Math.sin(degree)*FaceHeight/5));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*FaceHeight/12),(int)(mid.y - Math.sin(degree)*FaceHeight/12));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,SolidLineGreen);
        // 嘴唇中點垂直線 83
        canvas.drawLine(allPoint[95].x,allPoint[95].y - FaceHeight/10,allPoint[95].x,allPoint[95].y + FaceHeight/10,SolidLineRed);
        // 嘴唇水平 80 & 86
        canvas.drawLine(allPoint[92].x,allPoint[92].y,allPoint[98].x + FaceWidth/10,allPoint[92].y,SolidLineRed);
        canvas.drawLine(allPoint[98].x,allPoint[98].y,allPoint[98].x + FaceWidth/10,allPoint[98].y,SolidLineRed);

        // 畫點
        canvas.drawCircle(allPoint[124].x,allPoint[124].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[125].x,allPoint[125].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[126].x,allPoint[126].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[47].x,allPoint[47].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle((allPoint[50].x+allPoint[54].x)/2,(allPoint[50].y+allPoint[54].y)/2,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[58].x,allPoint[58].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[130].x,allPoint[130].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[5].x,allPoint[5].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[74].x,allPoint[74].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[81].x,allPoint[81].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[78].x,allPoint[78].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[83].x,allPoint[83].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[89].x,allPoint[89].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[87].x,allPoint[87].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[65].x,allPoint[65].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[66].x,allPoint[66].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[67].x,allPoint[67].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[69].x,allPoint[69].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[72].x,allPoint[72].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[68].x,allPoint[68].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[40].x,allPoint[40].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[93].x,allPoint[93].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[95].x,allPoint[95].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[96].x,allPoint[96].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[92].x,allPoint[92].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[98].x,allPoint[98].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[103].x,allPoint[103].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[100].x,allPoint[100].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[112].x,allPoint[112].y,DotSizeSmaller,DotWhite);
        canvas.drawCircle(allPoint[44].x,allPoint[44].y,DotSizeSmaller,DotWhite);

        canvas.drawLine(allPoint[124].x, allPoint[124].y, allPoint[125].x, allPoint[125].y, SolidLineWhite);
        canvas.drawLine(allPoint[126].x, allPoint[126].y, allPoint[125].x, allPoint[125].y, SolidLineWhite);
        canvas.drawLine(allPoint[124].x, allPoint[124].y, (allPoint[50].x+allPoint[54].x)/2,(allPoint[50].y+allPoint[54].y)/2, SolidLineWhite);
        canvas.drawLine(allPoint[125].x, allPoint[125].y, (allPoint[50].x+allPoint[54].x)/2,(allPoint[50].y+allPoint[54].y)/2, SolidLineWhite);
        canvas.drawLine(allPoint[126].x, allPoint[126].y, (allPoint[50].x+allPoint[54].x)/2,(allPoint[50].y+allPoint[54].y)/2, SolidLineWhite);
        canvas.drawLine(allPoint[124].x, allPoint[124].y, allPoint[47].x, allPoint[47].y, SolidLineWhite);
        canvas.drawLine(allPoint[124].x, allPoint[124].y, allPoint[130].x, allPoint[130].y, SolidLineWhite);
        canvas.drawLine(allPoint[126].x, allPoint[126].y, allPoint[58].x, allPoint[58].y, SolidLineWhite);
        canvas.drawLine(allPoint[126].x, allPoint[126].y, allPoint[5].x, allPoint[5].y, SolidLineWhite);
        canvas.drawLine(allPoint[47].x, allPoint[47].y, allPoint[74].x, allPoint[74].y, SolidLineWhite);
        canvas.drawLine(allPoint[58].x, allPoint[58].y, allPoint[87].x, allPoint[87].y, SolidLineWhite);
        canvas.drawLine(allPoint[47].x, allPoint[47].y, allPoint[74].x, allPoint[74].y, SolidLineWhite);
        canvas.drawLine(allPoint[130].x, allPoint[130].y, allPoint[74].x, allPoint[74].y, SolidLineWhite);
        canvas.drawLine(allPoint[81].x, allPoint[81].y, allPoint[74].x, allPoint[74].y, SolidLineWhite);
        canvas.drawLine(allPoint[81].x, allPoint[81].y, allPoint[78].x, allPoint[78].y, SolidLineWhite);
        canvas.drawLine(allPoint[130].x, allPoint[130].y, allPoint[78].x, allPoint[78].y, SolidLineWhite);
        canvas.drawLine(allPoint[5].x, allPoint[5].y, allPoint[83].x, allPoint[83].y, SolidLineWhite);
        canvas.drawLine(allPoint[89].x, allPoint[89].y, allPoint[83].x, allPoint[83].y, SolidLineWhite);
        canvas.drawLine(allPoint[89].x, allPoint[89].y, allPoint[87].x, allPoint[87].y, SolidLineWhite);
        canvas.drawLine(allPoint[5].x, allPoint[5].y, allPoint[87].x, allPoint[87].y, SolidLineWhite);
        canvas.drawLine(allPoint[74].x, allPoint[74].y, allPoint[68].x, allPoint[68].y, SolidLineWhite);
        canvas.drawLine(allPoint[87].x, allPoint[87].y, allPoint[40].x, allPoint[40].y, SolidLineWhite);
        canvas.drawLine((allPoint[50].x+allPoint[54].x)/2,(allPoint[50].y+allPoint[54].y)/2, allPoint[78].x, allPoint[78].y, SolidLineWhite);
        canvas.drawLine((allPoint[50].x+allPoint[54].x)/2,(allPoint[50].y+allPoint[54].y)/2, allPoint[83].x, allPoint[83].y, SolidLineWhite);
        canvas.drawLine(allPoint[78].x, allPoint[78].y, allPoint[67].x, allPoint[67].y, SolidLineWhite);
        canvas.drawLine(allPoint[83].x, allPoint[83].y, allPoint[67].x, allPoint[67].y, SolidLineWhite);
        canvas.drawLine(allPoint[78].x, allPoint[78].y, allPoint[65].x, allPoint[65].y, SolidLineWhite);
        canvas.drawLine(allPoint[83].x, allPoint[83].y, allPoint[66].x, allPoint[66].y, SolidLineWhite);
        canvas.drawLine(allPoint[81].x, allPoint[81].y, allPoint[65].x, allPoint[65].y, SolidLineWhite);
        canvas.drawLine(allPoint[89].x, allPoint[89].y, allPoint[66].x, allPoint[66].y, SolidLineWhite);
        canvas.drawLine(allPoint[69].x, allPoint[69].y, allPoint[65].x, allPoint[65].y, SolidLineWhite);
        canvas.drawLine(allPoint[72].x, allPoint[72].y, allPoint[66].x, allPoint[66].y, SolidLineWhite);
        canvas.drawLine(allPoint[69].x, allPoint[69].y, allPoint[67].x, allPoint[67].y, SolidLineWhite);
        canvas.drawLine(allPoint[72].x, allPoint[72].y, allPoint[67].x, allPoint[67].y, SolidLineWhite);
        canvas.drawLine(allPoint[69].x, allPoint[69].y, allPoint[92].x, allPoint[92].y, SolidLineWhite);
        canvas.drawLine(allPoint[72].x, allPoint[72].y, allPoint[98].x, allPoint[98].y, SolidLineWhite);
        canvas.drawLine(allPoint[68].x, allPoint[68].y, allPoint[112].x, allPoint[112].y, SolidLineWhite);
        canvas.drawLine(allPoint[40].x, allPoint[40].y, allPoint[44].x, allPoint[44].y, SolidLineWhite);
        canvas.drawLine(allPoint[112].x, allPoint[112].y, allPoint[44].x, allPoint[44].y, SolidLineWhite);
        canvas.drawLine(allPoint[112].x, allPoint[112].y, allPoint[92].x, allPoint[92].y, SolidLineWhite);
        canvas.drawLine(allPoint[98].x, allPoint[98].y, allPoint[44].x, allPoint[44].y, SolidLineWhite);
        canvas.drawLine(allPoint[100].x, allPoint[100].y, allPoint[44].x, allPoint[44].y, SolidLineWhite);
        canvas.drawLine(allPoint[112].x, allPoint[112].y, allPoint[103].x, allPoint[103].y, SolidLineWhite);
        canvas.drawLine(allPoint[98].x, allPoint[98].y, allPoint[100].x, allPoint[100].y, SolidLineWhite);
        canvas.drawLine(allPoint[93].x, allPoint[93].y, allPoint[95].x, allPoint[95].y, SolidLineWhite);
        canvas.drawLine(allPoint[96].x, allPoint[96].y, allPoint[95].x, allPoint[95].y, SolidLineWhite);
        canvas.drawLine(allPoint[96].x, allPoint[96].y, allPoint[98].x, allPoint[98].y, SolidLineWhite);
        canvas.drawLine(allPoint[100].x, allPoint[100].y, allPoint[98].x, allPoint[98].y, SolidLineWhite);
        canvas.drawLine(allPoint[100].x, allPoint[100].y, allPoint[103].x, allPoint[103].y, SolidLineWhite);
        canvas.drawLine(allPoint[92].x, allPoint[92].y, allPoint[103].x, allPoint[103].y, SolidLineWhite);
        canvas.drawLine(allPoint[92].x, allPoint[92].y, allPoint[93].x, allPoint[93].y, SolidLineWhite);

        return dst;
    }