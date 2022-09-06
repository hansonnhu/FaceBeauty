package com.joe.google_upload;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.DashPathEffect;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Point;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.Region;
import android.graphics.RegionIterator;
import android.graphics.Typeface;
import android.graphics.pdf.PdfDocument;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.constraintlayout.solver.widgets.Rectangle;
import com.google.android.material.tabs.TabLayout;
import androidx.core.content.FileProvider;
import androidx.core.graphics.ColorUtils;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;
import androidx.appcompat.app.AppCompatActivity;
import android.text.SpannableStringBuilder;
import android.util.Log;
import android.view.Display;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.github.mikephil.charting.charts.BarChart;
import com.github.mikephil.charting.charts.RadarChart;
import com.github.mikephil.charting.components.AxisBase;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.BarEntry;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.RadarData;
import com.github.mikephil.charting.data.RadarDataSet;
import com.github.mikephil.charting.data.RadarEntry;
import com.github.mikephil.charting.data.RadarPointBean;
import com.github.mikephil.charting.formatter.IAxisValueFormatter;
import com.github.mikephil.charting.formatter.IValueFormatter;
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.renderer.XAxisRendererRadarChart;
import com.github.mikephil.charting.utils.MPPointF;
import com.github.mikephil.charting.utils.RadarUtils;
import com.github.mikephil.charting.utils.ViewPortHandler;
import com.sothree.slidinguppanel.SlidingUpPanelLayout;
import com.viewpagerindicator.CirclePageIndicator;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;


public class Result_comment extends AppCompatActivity {

    private final int FACE = 500;
    private final int EYE = 501;
    private final int LIPS = 502;
    private final int EYEBROWS = 503;
    private final int NOSE = 504;
    private final int FOREHEAD = 505;
    private final int CHIN = 506;

    private ViewPager viewPager;
    private ViewPagerAdapter viewPagerAdapter;
    private TabLayout tabLayout;
    private Button btnBack;
    private SlidingUpPanelLayout slidePanel;
    private LinearLayout vpBar;
    private MarqueeTextView tvMarquee;
    private ProgressBar progressBar;

    private Bundle data;
    private TextView tvMark;
    private TextView tvTime;
    private ViewPager vpResult;
    private CirclePageIndicator circlePageIndicator;
    private List<ImageView> ivList = new ArrayList<ImageView>();
    private ImageView ivFakeFace;
    private ImageView ivFakeFace2;
    private ImageView ivFakeFace3;
    private ImageView ivFace;
    private ImageView ivForeHead;
    private ImageView ivEyeBrows;
    private ImageView ivEye;
    private ImageView ivNose;
    private ImageView ivLips;
    private ImageView ivChin;
    private TextView tvFace;
    private TextView tvForeHead;
    private TextView tvEyeBrows;
    private TextView tvEye;
    private TextView tvNose;
    private TextView tvLips;
    private TextView tvChin;



    private RadarChart radarChart;
    private LinearLayout llContainer;

    private Button btnPDF;

    //    private final Point[] allPoint = new Point[107];
    private final Point[] allPoint = new Point[148];
    private final Point[] tempPoint = new Point[148];
    // 左邊眉毛
    private Point EyebrowLeftTopPoint;     // 左眉上緣點
    private Point EyebrowLeftDownPoint;    // 左眉下緣點
    private Point EyebrowLeftLeftPoint;    // 左眉左緣點
    private Point EyebrowLeftRightPoint;   // 左眉右緣點
    // 右邊眉毛
    private Point EyebrowRightTopPoint;    // 右眉上緣點
    private Point EyebrowRightDownPoint;   // 右眉下緣點
    private Point EyebrowRightLeftPoint;   // 右眉左緣點
    private Point EyebrowRightRightPoint;  // 右眉右緣點
    // 左邊眼睛
    private Point EyeLeftTopPoint;    //左眼上緣點
    private Point EyeLeftDownPoint;   //左眼下緣點
    private Point EyeLeftLeftPoint;   //左眼左緣點
    private Point EyeLeftRightPoint;  //左眼右緣點
    // 右邊眼睛
    private Point EyeRightTopPoint;   //右眼上緣點
    private Point EyeRightDownPoint;  //右眼下緣點
    private Point EyeRightLeftPoint;  //右眼左緣點
    private Point EyeRightRightPoint; //右眼右緣點
    // 鼻子
    private Point NoseLeftPoint;      //鼻子左點
    private Point NoseRightPoint;     //鼻子右點
    private Point NoseLowPoint;       //鼻子底點
    // 嘴唇
    private Point LipsLeftPoint;      //嘴唇左緣點
    private Point LipsRightPoint;     //嘴唇右緣點
    private int UpLipThickness;   //上唇厚度
    private int DownLipThickness; //下唇厚度
    private Point MouthLeftPoint;     //嘴唇左點
    private Point MouthRightPoint;    //嘴唇右點
    private Point MouthPeak;          //唇峰
    private Point MouthValley;        //唇谷
    // 臉
    private Point FaceTopPoint;       //臉上緣點
    private Point FaceLowPoint;       //臉下緣點
    private Point FaceLeftPoint;      //臉左緣點
    private Point FaceRightPoint;      //臉右緣點
    private int FaceWidth;   //臉寬
    private int FaceHeight; //臉高
    // 其他數據
    private int EyebrowToChin;//眉毛到下巴距離
    private int NoseWidth;     // 鼻子寬度
    private int MouthWidth;  // 嘴巴寬度
    // 比例
    private double FiveEyeRightEyeOuter;
    private double FiveEyeRightEyeInner;
    private double FiveEyeCenter;
    private double FiveEyeLeftEyeInner;
    private double FiveEyeLeftEyeOuter;
    private double ThreeCourtTop;
    private double ThreeCourtCenter;
    private double ThreeCourtLow;
    //四端點
    private int mostTopPoint;
    private int mostBotPoint;
    private int mostLeftPoint;
    private int mostRightPoint;

    private Bitmap face;

    private String DetailComment;
    private Bitmap cropBitmap;



    private void bindViews(){
        data = getIntent().getExtras();

        btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        slidePanel = findViewById(R.id.SlidePanel);
        vpBar = findViewById(R.id.vpBar);
        tvMarquee = findViewById(R.id.tvMarquee);
        tvMark = findViewById(R.id.tvMark);
        tvTime = findViewById(R.id.tvTime);
        viewPager = findViewById(R.id.viewPager);
        vpResult = findViewById(R.id.vpResult);
        vpResult.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,(int)Utils.dp2px(this,Utils.getScreenHeightPx(this)/5)));
        circlePageIndicator = findViewById(R.id.CirclePageindicator);
        tabLayout = findViewById(R.id.tabLayout);
        progressBar = findViewById(R.id.progressBar);

        tvTime.setText(data.getString("Time"));
        ivFakeFace = findViewById(R.id.ivFakeFace);
        ivFakeFace2 = findViewById(R.id.ivFakeFace2);
        ivFace = findViewById(R.id.ivFace);
        ivForeHead = findViewById(R.id.ivForeHead);
        ivEyeBrows = findViewById(R.id.ivEyeBrows);
        ivEye = findViewById(R.id.ivEye);
        ivNose = findViewById(R.id.ivNose);
        ivLips = findViewById(R.id.ivLips);
        ivChin = findViewById(R.id.ivChin);

        tvFace = findViewById(R.id.tvFace);
        tvForeHead = findViewById(R.id.tvForeHead);
        tvEyeBrows = findViewById(R.id.tvEyeBrows);
        tvEye = findViewById(R.id.tvEye);
        tvNose = findViewById(R.id.tvNose);
        tvLips = findViewById(R.id.tvLips);
        tvChin = findViewById(R.id.tvChin);

        radarChart = findViewById(R.id.radarChart);
        llContainer = findViewById(R.id.llContainer);
        DetailComment = data.getString("msgCommentsDetail");
        btnPDF = findViewById(R.id.btnPDF);

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_result_comment);
        bindViews();

        // 使用Thread，避免頁面切換過久
        new Thread(){
            @Override
            public void run() {
                viewPagerAdapter = new ViewPagerAdapter(
                        getSupportFragmentManager(),
                        data.getString("msgCommentsBasic"),
                        data.getString("msgCommentsDetail"),
                        data.getString("msgCommentsBasicCN"),
                        data.getString("msgCommentsDetailCN"));

                viewPager.setAdapter(viewPagerAdapter);
                radarChart.setVisibility(View.GONE);
                viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
                    @Override
                    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {}

                    @Override
                    public void onPageSelected(int position) {
                        if(position == 0){
                            llContainer.removeAllViews();
                            radarChart.setVisibility(View.GONE);
                            btnPDF.setVisibility(View.GONE);
                        }else if(position == 1){
                            radarChart.setVisibility(View.VISIBLE);
                            btnPDF.setVisibility(View.VISIBLE);
                            for(int i=0 ; i < tvList.size() ; ++i){
                                llContainer.addView(tvList.get(i));
                                llContainer.addView(barList.get(i));
                            }
                        }
                    }

                    @Override
                    public void onPageScrollStateChanged(int state) {}
                });
                tabLayout.setupWithViewPager(viewPager);

                slidePanel.addPanelSlideListener(new SlidingUpPanelLayout.PanelSlideListener() {
                    @Override
                    public void onPanelSlide(View panel, float slideOffset) {
                        if(slidePanel.getPanelState() == SlidingUpPanelLayout.PanelState.DRAGGING){
                            tvMarquee.setAlpha(slideOffset);
                            vpBar.setAlpha(1-slideOffset);
                        }
                    }

                    @Override
                    public void onPanelStateChanged(View panel, SlidingUpPanelLayout.PanelState previousState, SlidingUpPanelLayout.PanelState newState) {
                        if(newState == SlidingUpPanelLayout.PanelState.EXPANDED){
                            slidePanel.setCoveredFadeColor(Color.parseColor("#00000000"));
                            tvMarquee.setAlpha(1.0f);
                            vpBar.setAlpha(0.0f);
                        }else {
                            slidePanel.setCoveredFadeColor(Color.parseColor("#99000000"));
                            tvMarquee.setAlpha(0.0f);
                            vpBar.setAlpha(1.0f);
                        }
                    }
                });

                setPointData();
                setPanelData();
                setRadarChart();
                setBarChart();


                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        setAdapter();
                    }
                });
                viewHandler.sendEmptyMessage(1);
            }
        }.start();
    }
    private float[] getRatioFloat(String[] ratio){
        float[] ret = new float[ratio.length];
        for(int i=0 ; i < ratio.length ; ++i){
            ret[i] = Float.valueOf(ratio[i].substring(ratio[i].indexOf(":")+1));
        }
        return ret;
    }

    public void outputToFile(String fileName, String pdfContent, String encoding) {//產生PDF
        File newFile = new File(Environment.getExternalStorageDirectory() + "/" + fileName);
        try {
            newFile.createNewFile();
            try {
                FileOutputStream pdfFile = new FileOutputStream(newFile);
                pdfFile.write(pdfContent.getBytes(encoding));
                pdfFile.close();
            } catch(FileNotFoundException e) {
                // ...
            }
        } catch(IOException e) {
            // ...
        }

    }

    private String autoLinebreak(String sourcetext, int width)
    {

        //初始化回傳斷行結果的字串
        String resultstr = "";

        return resultstr;
    }

    //region viewHandler
    @SuppressLint("HandlerLeak")
    Handler viewHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if(msg.what == 0){
                //ivFakeFace.setImageBitmap((Bitmap) msg.getData().getParcelable("scaledFake"));
                ivFakeFace2.setImageBitmap(drawFakeonlypoint(originFake));
            }else if(msg.what == 1){
                final String marqueeText =
//                        tvFace.getText().toString() + "　　" +
//                        tvForeHead.getText().toString() + "　　" +
                        tvChin.getText().toString() + "　　" +
                                tvEyeBrows.getText().toString() + "　　" +
                                tvEye.getText().toString() + "　　" +
                                tvNose.getText().toString() + "　　" +
                                tvLips.getText().toString();// + "　　" +
//                        tvChin.getText().toString();
                tvMarquee.setText(marqueeText);
                tvMarquee.setAlpha(0.0f);
                progressBar.setVisibility(View.GONE);
                viewPager.setVisibility(View.VISIBLE);
            }else if(msg.what == FACE){
                ivFace.setImageBitmap((Bitmap) msg.getData().getParcelable("Bitmap"));
                tvFace.setText(msg.getData().getString("Comment"));
            }else if(msg.what == EYEBROWS){
                ivEyeBrows.setImageBitmap((Bitmap) msg.getData().getParcelable("Bitmap"));
                tvEyeBrows.setText(msg.getData().getString("Comment"));
            }else if(msg.what == EYE){
                ivEye.setImageBitmap((Bitmap) msg.getData().getParcelable("Bitmap"));
                tvEye.setText(msg.getData().getString("Comment"));
            }else if(msg.what == NOSE){
                ivNose.setImageBitmap((Bitmap) msg.getData().getParcelable("Bitmap"));
                tvNose.setText(msg.getData().getString("Comment"));
            }else if(msg.what == LIPS){
                ivLips.setImageBitmap((Bitmap) msg.getData().getParcelable("Bitmap"));
                tvLips.setText(msg.getData().getString("Comment"));
            }else if(msg.what == FOREHEAD){
                ivForeHead.setImageBitmap((Bitmap) msg.getData().getParcelable("Bitmap"));
                tvForeHead.setText(msg.getData().getString("Comment"));
            }else if(msg.what == CHIN){
                ivChin.setImageBitmap((Bitmap) msg.getData().getParcelable("Bitmap"));
                tvChin.setText(msg.getData().getString("Comment"));
            }
        }
    };
    //endregion

    private float radarLabelX;
    private float radarLabelY;
    private ArrayList<RadarEntry> radarYAxis = new ArrayList<>();
    private void setRadarChart(){
        final String[] ratio = data.getString("Ratio").split("\\+");
        final float[] ratioFloat = getRatioFloat(ratio);
        final ArrayList<String> titles = new ArrayList<>();
        titles.add(getResources().getString(R.string.Result_comment_face));//:臉長寬比");
        titles.add(getResources().getString(R.string.Result_comment_forehead));//:額頭高度比臉長");
        titles.add(getResources().getString(R.string.Result_comment_eye));//:眼寬除以眼高");
        titles.add(getResources().getString(R.string.Result_comment_philtrum));//:人中長度比臉寬");
        titles.add(getResources().getString(R.string.Result_comment_mouth));//:嘴唇寬度比臉寬");
        titles.add(getResources().getString(R.string.Result_comment_eyebrow));//:眉毛寬度除以高度");

//        final ArrayList<RadarEntry> radarYAxis = new ArrayList<>();
        radarYAxis.add(new RadarEntry(Float.valueOf(getScore(1.17f,2f,ratioFloat[2]))));
        radarYAxis.add(new RadarEntry(Float.valueOf(getScore(0.22f,0.5f,ratioFloat[11]))));
        radarYAxis.add(new RadarEntry(Float.valueOf(getScore(2.88f,4.5f,ratioFloat[23]))));
        radarYAxis.add(new RadarEntry(Float.valueOf(getScore(0.12f,0.5f,ratioFloat[28]))));
        radarYAxis.add(new RadarEntry(Float.valueOf(getScore(2f,10f,ratioFloat[30]))));
        radarYAxis.add(new RadarEntry(Float.valueOf(getScore(4.33f,10f,ratioFloat[15]))));
        setRadarChart(radarChart,titles,radarYAxis);
    }
    private void setRadarChart(final RadarChart radarChart,final ArrayList<String> titles,final ArrayList<RadarEntry> data){
        RadarDataSet set = new RadarDataSet(data,"甲方");   // 填入資料
        set.setDrawFilled(true);                                // 是否填滿圖形
        set.setLineWidth(2f);                                   // 輪廓寬度
        set.setColor(Color.parseColor("#FF0022ff"));   // 輪廓顏色
        set.setValueTextSize(0f);                               // 文字大小
        set.setValueTextColor(Color.WHITE);
        RadarData radarData = new RadarData(set);               // 綁定資料

        radarChart.setWebScale(0.85f);             // 自製function，不影響Label情況下，改變網子大小
        radarChart.setData(radarData);
        radarChart.setDescription(null);
        radarChart.getLegend().setEnabled(false);               // 取消圖例
        radarChart.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                List<RadarPointBean> pointBeans = RadarUtils.computePosition(radarChart);
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        radarLabelX = event.getX();
                        radarLabelY = event.getY();
                        break;
                    case MotionEvent.ACTION_UP:
                        for (int i = 0; i < pointBeans.size(); ++i) {
                            RadarPointBean pointBean = pointBeans.get(i);
                            if (pointBean.isIn(radarLabelX, radarLabelY)) {
                                detailInformation(i);
                                return true;
                            }
                        }
                        break;
                    default:

                        break;
                }
                return false;
            }
        });

        // 雷達圖 X軸為頂點， Y軸為有幾層(圈)

        final XAxis xAxis = radarChart.getXAxis();   // 取得X軸
        xAxis.setTextColor(Color.WHITE);       // X軸文字顏色
        xAxis.setTextSize(20f);                // X軸文字大小
//        xAxis.setMultiLineLabel(true);
        xAxis.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {
                if((int)value == 6) return "";
                return (titles.get((int)value));// + "\n" + data.get((int)value).getValue());
            }
        });
        final YAxis yAxis = radarChart.getYAxis();     // 取得Y軸
        yAxis.setTextColor(Color.TRANSPARENT);   // 隱藏Y軸文字(設為透明)
        yAxis.setLabelCount(6,true);  // Y軸label數量
        yAxis.setAxisMinimum(0);
        yAxis.setAxisMaximum(100);

        radarChart.setWebColor(Color.WHITE);       // 網子放射線條顏色
        radarChart.setWebAlpha(100);               // 網子放射線條透明度
        radarChart.setWebColorInner(Color.WHITE);  // 網子內圈顏色
        radarChart.setRotationEnabled(false);      // 網子不可滑動旋轉
        radarChart.invalidate();                   // 調用 onDraw() 繪製圖形
    }
    private String getScore(float avg,float max,float x){
        if(max == avg) return "100";
        DecimalFormat df = new DecimalFormat("#.00");
//        Log.i("MAPPMSG","Score: " + df.format(100 + (-100/(max-avg))*Math.abs(x - avg)));
        return df.format(100 + (-100/(max-avg))*Math.abs(x - avg));     //由於格式化只能回傳字串，回傳後必須在轉型
    }


    private static String[] titles = new String[]{"臉長寬比","額頭高度比臉長","眼寬除以眼高",
            "人中長度比臉寬","嘴唇寬度比臉寬","眉毛寬度除以高度"};//static

    public void onClick(View v) {
        switch(v.getId()){
            case R.id.btnPDF:
                String msgCommentsBasic = data.getString("msgCommentsBasic");
                String msgCommentsDetail = data.getString("msgCommentsDetail");
                SpannableStringBuilder builderBasic = new SpannableStringBuilder(msgCommentsBasic);
                SpannableStringBuilder builderDetail = new SpannableStringBuilder(msgCommentsDetail);


                Log.i("msgCommentsBasic",msgCommentsBasic);
                Log.i("msgCommentsDetail",msgCommentsDetail);

                Bitmap pointpic = drawBasiconlypoint(cropBitmap);

                File file = new File(Environment.getExternalStorageDirectory() + "/BeautyJudge/","hello_Paragraphs.pdf");
                PdfDocument pdfDocument = new PdfDocument();
                PdfDocument.PageInfo myPageInfo1 = new PdfDocument.PageInfo.Builder(1200,20000,1).create();
                PdfDocument.Page page = pdfDocument.startPage(myPageInfo1);
                Paint myPaint = new Paint();
                Paint ResultPaint = new Paint();
                Paint ResultPaintB = new Paint();//粗體

                Canvas canvas = page.getCanvas();//pdf畫人臉
                int NewWidth = 400;
                int NewHeight = (int)((float)((float)cropBitmap.getHeight()/(float)cropBitmap.getWidth()) * (float)NewWidth);
                Bitmap newBitmap = Bitmap.createScaledBitmap(cropBitmap, NewWidth,NewHeight, true);
                Bitmap newBitmap1 = Bitmap.createScaledBitmap(pointpic, NewWidth,NewHeight, true);
                canvas.drawBitmap(newBitmap,100,100,myPaint);
                canvas.drawBitmap(newBitmap1,200 + NewWidth,100,myPaint);
                //myPaint.setColor(Color.rgb(0,113,188));

                ResultPaint.setTextAlign(Paint.Align.LEFT);
                ResultPaint.setTypeface(Typeface.create(Typeface.DEFAULT,Typeface.NORMAL));
                ResultPaint.setTextSize(25);

                ResultPaintB.setTextAlign(Paint.Align.LEFT);
                ResultPaintB.setTypeface(Typeface.create(Typeface.DEFAULT,Typeface.NORMAL));
                ResultPaintB.setTextSize(30);
                ResultPaintB.setFakeBoldText(true);
                ResultPaintB.setTypeface(Typeface.DEFAULT_BOLD);

                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////刪除字串中的中大括弧
                msgCommentsBasic = msgCommentsBasic.replace("[","");
                msgCommentsBasic = msgCommentsBasic.replace("]","");
                msgCommentsBasic = msgCommentsBasic.replace("{","");
                msgCommentsBasic = msgCommentsBasic.replace("}","");
                msgCommentsBasic = msgCommentsBasic.replace("：","：\n");


                msgCommentsDetail = msgCommentsDetail.replace("[","");
                msgCommentsDetail = msgCommentsDetail.replace("]","");
                msgCommentsDetail = msgCommentsDetail.replace("{","");
                msgCommentsDetail = msgCommentsDetail.replace("}","");
                msgCommentsDetail = msgCommentsDetail.replace("：","：\n");
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                String newmsgCommentsBasic = "";
                for (String line: msgCommentsBasic.split("\n")) {

                    if(line.length()>41) {
                        for (int i = 0; i < line.length() / 41; i++) {
                            newmsgCommentsBasic = newmsgCommentsBasic + line.substring(i * 41, (i + 1) * 41) + "\n";
                        }
                        newmsgCommentsBasic = newmsgCommentsBasic + line.substring(((line.length() / 41)) * 41, line.length()) + "\n";
                    }
                    else
                    {
                        newmsgCommentsBasic = newmsgCommentsBasic + line + "\n";
                    }
                }

                String newmsgCommentsDetail = "";
                for (String line: msgCommentsDetail.split("\n")) {
                    if(line.length()>41) {
                        for (int i = 0; i < line.length() / 41; i++) {
                            newmsgCommentsDetail = newmsgCommentsDetail + line.substring(i * 41, (i + 1) * 41) + "\n";
                        }
                        newmsgCommentsDetail = newmsgCommentsDetail + line.substring(((line.length() / 41)) * 41, line.length()) + "\n";
                    }
                    else
                    {
                        newmsgCommentsDetail = newmsgCommentsDetail + line + "\n";
                    }

                }

                msgCommentsBasic = newmsgCommentsBasic;
                msgCommentsDetail = newmsgCommentsDetail;
        /*canvas.drawText("臉型：",100,NewHeight + 200,ResultPaint);
        canvas.drawText(msgCommentsBasic,100,NewHeight + 250,ResultPaint);
        canvas.drawText(msgCommentsDetail,100,NewHeight + 300,ResultPaint);*/
                int x = 100, y = NewHeight + 200;
                canvas.drawText("簡要斷語", x, y, ResultPaintB);
                y += 50;
                for (String line: msgCommentsBasic.split("\n")) {

                    Log.i("冒號",Integer.toString(line.indexOf("：")));

                    if(line.indexOf("：") != -1 || line.indexOf("　") != -1) {//讀到冒號跟空白就粗體
                        canvas.drawText(line, x, y, ResultPaintB);
                        y += 50;
                    }
                    else
                    {
                        canvas.drawText(line, x, y, ResultPaint);
                        y += 50;
                    }
                }

                y += 50;
                canvas.drawText("詳細斷語", x, y, ResultPaintB);
                y += 50;
                for (String line: msgCommentsDetail.split("\n")) {
                    if(line.indexOf("：") != -1 || line.indexOf("　") != -1) {
                        canvas.drawText(line, x, y, ResultPaintB);
                        y += 50;

                    }
                    else
                    {
                        canvas.drawText(line, x, y, ResultPaint);
                        y += 50;
                    }

                }

                pdfDocument.finishPage(page);
                try {

                    FileOutputStream fos = new FileOutputStream(file);
                    pdfDocument.writeTo(fos);
                    pdfDocument.close();
                    fos.close();

                } catch (IOException e) {
                    throw new RuntimeException("Error generating file", e);
                }



                Intent intent1 = new Intent(Intent.ACTION_VIEW);//用其他程式開PDF\
                intent1.addCategory("android.intent.category.DEFAULT");
                intent1.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                Uri uri = FileProvider.getUriForFile(this, this.getApplicationContext().getPackageName() + ".provider", file);
                //uri = Uri.parse("file:///storage/emulated/0/BeautyJudge/hello_Paragraphs.pdf");
                Log.i("URL",uri.toString());
                intent1.setDataAndType(uri, "application/pdf");

                startActivity(intent1);

                break;
        }
    }

    private void detailInformation(int position){
        final Dialog dialog = new Dialog(this);
        dialog.setContentView(R.layout.radar_xlabel_touch);
        TextView tvTitle = dialog.findViewById(R.id.tvTitle);
        TextView tvScore = dialog.findViewById(R.id.tvScore);
        TextView tvTitleScore = dialog.findViewById(R.id.tvTitleScore);
        ImageView iv = dialog.findViewById(R.id.iv);
        Button btnClose = dialog.findViewById(R.id.btnClose);

        tvTitle.setText(titles[position]);
//        tvTitle.setText(": " + getDetailScore(position));
        tvScore.setText(getResources().getString(R.string.Result_comment_score) + radarYAxis.get(position).getValue() + " / 100");
        tvTitleScore.setText(titles[position] + ": " + getDetailScore(position));
        iv.setImageBitmap(getDetailFake(position));
        btnClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
            }
        });
        dialog.show();
        Display display = getWindowManager().getDefaultDisplay();
        dialog.getWindow().setLayout((int)(display.getWidth() * 0.8),(int)Utils.dp2px(this,450));
    }
    private String getDetailScore(int position){
        double score = 0.0;
        if(position == 0){
            score = (double)(allPoint[123].y - allPoint[125].y) / (allPoint[24].x - allPoint[1].x);
        }else if(position == 1){
            Point mid = new Point((allPoint[50].x + allPoint[54].x)/2,(allPoint[50].y + allPoint[54].y)/2);
            score = (double)(mid.y - allPoint[125].y) / (allPoint[123].y - allPoint[125].y);
        }else if(position == 2){
            score = (double)(allPoint[87].x - allPoint[63].x) / (allPoint[89].y - allPoint[85].y);
        }else if(position == 3){
            score = (double)(allPoint[95].y - allPoint[71].y) / (allPoint[24].x - allPoint[1].x);
        }else if(position == 4){
            score = (double)(allPoint[98].x - allPoint[92].x) / (allPoint[24].x - allPoint[1].x);
        }else if(position == 5){
            score = (double)(allPoint[59].x - allPoint[54].x) / (allPoint[61].y - allPoint[56].y);
        }
        return String.format("%.2f",score);
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////detail
    /////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////
    private Bitmap getDetailFake(int position) {
        Bitmap ret = null;
        Canvas canvas;

        if(position == 0){ // 臉長寬比
            Paint SolidLineGreen = newPaintLine("#00ff00", (float) FaceWidth / 50, Paint.Style.STROKE);
            Paint SolidLineRed = newPaintLine("#ff0000", (float) FaceWidth / 50, Paint.Style.STROKE);

            ret = originFake.copy(Bitmap.Config.ARGB_8888, true);
            canvas = new Canvas(ret);
            drawTria(canvas, allPoint[123].x, allPoint[123].y, allPoint[123].x, allPoint[125].y, FaceWidth / 15, FaceWidth / 20, SolidLineRed, SolidLineRed);
            drawTria(canvas, allPoint[24].x, allPoint[24].y, allPoint[1].x, allPoint[1].y, FaceWidth / 15, FaceWidth / 20, SolidLineGreen, SolidLineGreen);
        }else if(position == 1){ // 額頭高度比臉長
            Paint SolidLineGreen = newPaintLine("#00ff00", (float) FaceWidth / 60, Paint.Style.STROKE);
            Paint SolidLineRed = newPaintLine("#ff0000", (float) FaceWidth / 60, Paint.Style.STROKE);

            ret = originFake.copy(Bitmap.Config.ARGB_8888,true);
            canvas = new Canvas(ret);
            Point mid = new Point((allPoint[50].x + allPoint[54].x)/2,(allPoint[50].y + allPoint[54].y)/2);
            drawTria(canvas,allPoint[125].x,allPoint[125].y,allPoint[125].x,mid.y,FaceWidth/15,FaceWidth/20,SolidLineRed,SolidLineRed);
            drawTria(canvas,allPoint[125].x - FaceWidth/10,allPoint[125].y,allPoint[125].x - FaceWidth/10,allPoint[123].y,FaceWidth/15,FaceWidth/20,SolidLineGreen,SolidLineGreen);
        }else if(position == 2){ // 眼寬除以眼高
            int width = allPoint[87].x - allPoint[83].x + FaceWidth/30;
            int height = allPoint[89].y - allPoint[85].y + FaceWidth/30;
            Paint SolidLineGreen = newPaintLine("#00ff00", (float) width /60, Paint.Style.STROKE);
            Paint SolidLineRed = newPaintLine("#ff0000", (float) width / 60, Paint.Style.STROKE);

            int moveX = allPoint[83].x - width/3;
            int moveY = allPoint[85].y - width/3;

            ret = Bitmap.createBitmap(originFake.getWidth(),originFake.getHeight(), Bitmap.Config.ARGB_8888);
            canvas = new Canvas(ret);
            canvas.drawARGB(0,0,0,0);
            Paint blackPaint = newPaintLine("#000000",(float)FaceWidth/150, Paint.Style.FILL);
            Paint whitePaint = newPaintLine("#ffffff",(float)FaceWidth/1500, Paint.Style.FILL);
            ArrayList<Point> points = new ArrayList<>();
            int scale = 2;
            // 右眼
            points.add(new Point((allPoint[83].x - moveX)*scale,(allPoint[83].y - moveY)*scale));
            points.add(new Point((allPoint[84].x - moveX)*scale,(allPoint[84].y - moveY)*scale));
            points.add(new Point((allPoint[85].x - moveX)*scale,(allPoint[85].y - moveY)*scale));
            points.add(new Point((allPoint[86].x - moveX)*scale,(allPoint[86].y - moveY)*scale));
            points.add(new Point((allPoint[87].x - moveX)*scale,(allPoint[87].y - moveY)*scale));
            points.add(new Point((allPoint[88].x - moveX)*scale,(allPoint[88].y - moveY)*scale));
            points.add(new Point((allPoint[89].x - moveX)*scale,(allPoint[89].y - moveY)*scale));
            points.add(new Point((allPoint[91].x - moveX)*scale,(allPoint[91].y - moveY)*scale));

            drawCurve(canvas,points,whitePaint,true);
            Path path = new Path();
            path.addCircle((points.get(2).x+points.get(6).x)/2,(points.get(2).y+points.get(6).y)/2,(points.get(6).y-points.get(2).y)/2,Path.Direction.CW);
            canvas.drawPath(path,blackPaint);
            path.reset();
            // 長、寬
            drawTria(canvas,points.get(0).x,points.get(2).y,points.get(4).x,points.get(2).y,width/15,width/20,SolidLineRed,SolidLineRed);
            drawTria(canvas,points.get(4).x,points.get(2).y,points.get(4).x,points.get(6).y,width/15,width/20,SolidLineGreen,SolidLineGreen);
            ret = Bitmap.createBitmap(ret,points.get(0).x - width/5,points.get(2).y - width/5,width*scale + width/5,height*scale,null,true);
        }else if(position == 3){ // 人中長度比臉寬
            Paint SolidLineGreen = newPaintLine("#009c00", (float) FaceWidth / 60, Paint.Style.STROKE);
            Paint SolidLineRed = newPaintLine("#ff0000", (float) FaceWidth / 60, Paint.Style.STROKE);

            ret = originFake.copy(Bitmap.Config.ARGB_8888,true);
            canvas = new Canvas(ret);
            canvas.drawLine(allPoint[71].x,allPoint[71].y,allPoint[71].x,allPoint[95].y,SolidLineGreen);
            canvas.drawLine(allPoint[71].x - FaceWidth/15,allPoint[71].y,allPoint[71].x + FaceWidth/15,allPoint[71].y,SolidLineGreen);
            canvas.drawLine(allPoint[95].x - FaceWidth/15,allPoint[95].y,allPoint[71].x + FaceWidth/15,allPoint[95].y,SolidLineGreen);
            drawTria(canvas,allPoint[24].x,allPoint[24].y,allPoint[1].x,allPoint[1].y,FaceWidth/15,FaceWidth/20,SolidLineRed,SolidLineRed);
        }else if(position == 4){ // 嘴唇寬度比臉寬
            Paint SolidLineGreen = newPaintLine("#009c00", (float) FaceWidth / 60, Paint.Style.STROKE);
            Paint SolidLineRed = newPaintLine("#ff0000", (float) FaceWidth / 60, Paint.Style.STROKE);

            ret = originFake.copy(Bitmap.Config.ARGB_8888,true);
            canvas = new Canvas(ret);
            drawTria(canvas,allPoint[92].x,allPoint[96].y,allPoint[98].x,allPoint[96].y,FaceWidth/15,FaceWidth/20,SolidLineGreen,SolidLineGreen);
            drawTria(canvas,allPoint[24].x,allPoint[24].y,allPoint[1].x,allPoint[1].y,FaceWidth/15,FaceWidth/20,SolidLineRed,SolidLineRed);
        }else if(position == 5){ // 眉毛寬度除以高度
            int width = allPoint[59].x - allPoint[54].x + FaceWidth/20;
            int height = allPoint[61].y - allPoint[56].y + FaceWidth/20;
            Paint SolidLineGreen = newPaintLine("#00ff00", (float) width / 100, Paint.Style.STROKE);
            Paint SolidLineRed = newPaintLine("#ff0000", (float) width / 100, Paint.Style.STROKE);

            ret = Bitmap.createBitmap(originFake.getWidth(),originFake.getHeight(), Bitmap.Config.ARGB_8888);
            canvas = new Canvas(ret);
            canvas.drawARGB(0,0,0,0);

            Paint eyeBrowPaint = newPaintLine("#533130",(float)FaceWidth/200, Paint.Style.FILL);
            ArrayList<Point> points = new ArrayList<>();
            points.add(allPoint[54]); points.add(allPoint[55]); points.add(allPoint[56]); points.add(allPoint[58]);
            points.add(allPoint[59]); points.add(allPoint[60]); points.add(allPoint[61]); points.add(allPoint[62]);
            drawCurve(canvas,points,eyeBrowPaint,true);
            points.clear();
            drawTria(canvas,allPoint[56].x,allPoint[56].y,allPoint[56].x,allPoint[59].y,width/20, width/25, SolidLineRed,SolidLineRed);
            drawTria(canvas,allPoint[54].x,allPoint[59].y,allPoint[59].x,allPoint[59].y,width/20, width/25, SolidLineGreen, SolidLineGreen);
            ret = Bitmap.createBitmap(ret,allPoint[54].x - FaceWidth/70,allPoint[56].y - FaceWidth/70,width,height,null,true);
        }else
            return originFake;
        return ret;
    }



    private void setBarChart(){
        getTotalFromServer();
    }
    private void setBarChart(BarChart barChart,float left,float right,int[] total){
        float range = (right - left)/20;
        final ArrayList<String> xData = new ArrayList<>();
        if(left == 0f) xData.add(left+"");
        else xData.add("<"+left);
//        left == 0f? xData.add(left+"") : xData.add("<"+left);
//        xData.add("<"+left);
        xData.add(""); xData.add("");
        xData.add(String.format("%.2f",left+range*2));// + "\n~\n" + String.format("%.2f",left+range*3));
        xData.add(""); xData.add("");
        xData.add(String.format("%.2f",left+range*5));// + "\n~\n" + String.format("%.2f",left+range*6));
        xData.add(""); xData.add("");
        xData.add(String.format("%.2f",left+range*8));// + "\n~\n" + String.format("%.2f",left+range*9));
        xData.add(""); xData.add("");
        xData.add(String.format("%.2f",left+range*11));// + "\n~\n" + String.format("%.2f",left+range*9));
        xData.add(""); xData.add("");
        xData.add(String.format("%.2f",left+range*14));// + "\n~\n" + String.format("%.2f",left+range*9));
        xData.add(""); xData.add("");
        xData.add(String.format("%.2f",left+range*17));// + "\n~\n" + String.format("%.2f",left+range*9));
        xData.add(""); xData.add("");
        xData.add(">"+right);
        final ArrayList<BarEntry> yData = new ArrayList<>();
        for(int i=0 ; i < 22 ; ++i) {
            yData.add(new BarEntry(i, total[i]));
        }
        setBarChart(barChart,xData,yData);
    }
    private void setBarChart(BarChart barChart,final ArrayList<String> xData,final ArrayList<BarEntry> yData){
        BarDataSet barDataSet = new BarDataSet(yData,"");    // 綁定資料
        barDataSet.setValueTextSize(0f);                         // bar上方文字大小
        barDataSet.setValueTextColor(Color.TRANSPARENT);                // bar上方文字顏色
        barDataSet.setColor(Color.CYAN);                          // bar本體顏色
        barDataSet.setValueFormatter(new IValueFormatter() {
            @Override
            public String getFormattedValue(float value, Entry entry, int dataSetIndex, ViewPortHandler viewPortHandler) {
                return ""+((int)value);
            }
        });

        BarData barData = new BarData(barDataSet);
//        barData.setBarWidth(0.7f);           // Bar的寬度(原本的一半)
        barChart.setData(barData);
        barChart.setDescription(null);
        barChart.getLegend().setEnabled(false);                   //取消圖例
        barChart.setViewPortOffsets(Utils.dp2px(Result_comment.this,20),    // 整張圖與邊界的距離
                Utils.dp2px(Result_comment.this,10),
                Utils.dp2px(Result_comment.this,20),
                Utils.dp2px(Result_comment.this,40));

        final XAxis xAxis = barChart.getXAxis();   // 取得X軸
        xAxis.setTextSize(18f);                    // X軸文字大小
        xAxis.setTextColor(Color.WHITE);           // X軸文字顏色
        xAxis.setPosition(XAxis.XAxisPosition.BOTTOM);  // X軸文字位置
        xAxis.setDrawGridLines(false);
        xAxis.setLabelCount(22);
        xAxis.setMultiLineLabel(true);
//        xAxis.setSpaceMax(8f);
        xAxis.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {
//                Log.i("MAPPMSG","Value: " + value);
                if((int)value >= 22) return "";
                return xData.get((int)value);
            }
        });

//        final YAxis leftAxis = barChart.getAxisLeft();  // 取得左Y軸
//        leftAxis.setTextSize(18f);                 // Y軸文字大小
//        leftAxis.setTextColor(Color.WHITE);        // Y軸文字顏色
//        leftAxis.setDrawAxisLine(false);           // 是否繪製Y軸
//        leftAxis.setAxisMinimum(0);
        barChart.getAxisLeft().setEnabled(false);   // 取消左Y軸
        barChart.getAxisRight().setEnabled(false);  // 取消右Y軸

//            Log.i("MAPPMSG",""+highlightIndex[currentChart]);
//        barChart.highlightValue(new Highlight((float)highlightIndex,0f,0),false);  // bar高亮 (第幾個，???，第一組數據)
        barChart.setHighlightPerDragEnabled(false);   // bar是否可透過滑動改變高亮
        barChart.setHighlightPerTapEnabled(false);    // bar是否可透過點擊改變高亮
        barChart.setDoubleTapToZoomEnabled(false);    // 圖形是否可以縮放
        barChart.invalidate();                        // 調用 onDraw() 繪製圖形
    }

    private final ArrayList<TextView> tvList = new ArrayList<>();
    private final ArrayList<BarChart> barList = new ArrayList<>();
    private void getChartView(final String word,final float left,final float right,final int[] total, final int highlightIndex){
        TextView tv = new TextView(Result_comment.this);
        tv.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,(int) Utils.dp2px(Result_comment.this,50)));
        tv.setText(word);
        tv.setTextSize(20);
        tv.setGravity(Gravity.CENTER);
//        llContainer.addView(tv);
        tvList.add(tv);

        final BarChart barChart = new BarChart(Result_comment.this);
        barChart.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,(int) Utils.dp2px(Result_comment.this,200)));
        setBarChart(barChart,left,right,total);
        // must call here, or the chart won't set offset successfully
        barChart.post(new Runnable() {
            @Override
            public void run() {
                barChart.highlightValue(new Highlight((float)highlightIndex,0f,0),false);  // bar高亮 (第幾個，???，第一組數據)
            }
        });
//        llContainer.addView(barChart);
        barList.add(barChart);
    }
    private void getTotalFromServer(){
        new Thread(){
            @Override
            public void run() {
                Socket socket = new Socket();
                StringBuilder msg = new StringBuilder();
                String[] total = new String[34];
                int index=0;
                try{
                    SocketAddress socketAddress = new InetSocketAddress(Variable.ServerIP, 57575);
                    socket.connect(socketAddress,5000);

                    if(socket.isConnected()){
                        DataInputStream dis = new DataInputStream(socket.getInputStream());
                        byte b;
                        // 數字&數字&數字&數字&數字&數字&數字&數字&數字&數字&數字&數字&...數字& (共22) , 數字&數字&數字&數字&....>  (34)
                        while((b = dis.readByte()) != '>'){
                            if(b == ',') {
                                total[index++] = msg.toString();
                                msg.setLength(0);
                            }else
                                msg.append((char) (b & 0xFF));
                        }
                        final Message ThreadMessage = Message.obtain();
                        Bundle bundle = new Bundle();
                        bundle.putStringArray("Total",total);
                        ThreadMessage.setData(bundle);
                        ThreadMessage.what = Variable.SOCKET_SVR_FIN;
                        getHandler.sendMessage(ThreadMessage);
                    }else{
                        getHandler.sendEmptyMessage(Variable.SOCKET_SVR_OFF);
                    }
                }catch (IOException e) {
                    e.printStackTrace();
                    Log.i("MAPP", "Timeout!");
                    getHandler.sendEmptyMessage(Variable.SOCKET_SVR_OFF);
                } finally {
                    try {
                        socket.close();
                        Log.i("MAPPMSG", "Connection Ended.");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }.start();
    }
    private void sendTotalToServer(final int[] index){
        new Thread(){
            @Override
            public void run() {
                Socket socket = new Socket();
                try{
                    SocketAddress socketAddress = new InetSocketAddress(Variable.ServerIP, 57576);
                    socket.connect(socketAddress,5000);

                    if(socket.isConnected()){
                        DataOutputStream dos = new DataOutputStream(socket.getOutputStream());
                        StringBuilder data = new StringBuilder();
                        // 數字,數字,數字,數字,數字,....,;   (34) 範圍0-21
                        for(int i=0 ; i < index.length ; ++i){
                            data.append(index[i]);
                            data.append(",");
                        }
                        data.append(";");
                        byte[] sendData = data.toString().getBytes("UTF-8");
                        dos.write(sendData);
                    }else{
                        getHandler.sendEmptyMessage(Variable.SOCKET_SVR_OFF);
                    }
                }catch (IOException e) {
                    e.printStackTrace();
                    Log.i("MAPP", "Timeout!");
                    getHandler.sendEmptyMessage(Variable.SOCKET_SVR_OFF);
                } finally {
                    try {
                        socket.close();
                        Log.i("MAPPMSG", "Connection Ended.");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }.start();
    }

    private int getHighLightIndex(float num,float left,float right){
        float range = (right - left)/20;
        if(num < left) return 0;
        else if (num < left + range) return 1;
        else if (num < left + 2*range) return 2;
        else if (num < left + 3*range) return 3;
        else if (num < left + 4*range) return 4;
        else if (num < left + 5*range) return 5;
        else if (num < left + 6*range) return 6;
        else if (num < left + 7*range) return 7;
        else if (num < left + 8*range) return 8;
        else if (num < left + 9*range) return 9;
        else if (num < left + 10*range) return 10;
        else if (num < left + 11*range) return 11;
        else if (num < left + 12*range) return 12;
        else if (num < left + 13*range) return 13;
        else if (num < left + 14*range) return 14;
        else if (num < left + 15*range) return 15;
        else if (num < left + 16*range) return 16;
        else if (num < left + 17*range) return 17;
        else if (num < left + 18*range) return 18;
        else if (num < left + 19*range) return 19;
        else if (num < right) return 20;
        else return 21;
    }

    //region getHandler
    @SuppressLint("HandlerLeak")
    Handler getHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == Variable.SOCKET_SVR_OFF) {
                Toast.makeText(Result_comment.this, getResources().getString(R.string.Server_not_on), Toast.LENGTH_SHORT).show();
            } else if(msg.what == Variable.SOCKET_SVR_FULL) {
                Toast.makeText(Result_comment.this,  getResources().getString(R.string.Server_full), Toast.LENGTH_SHORT).show();
            } else if(msg.what == Variable.SOCKET_SVR_ERROR) {
                Toast.makeText(Result_comment.this,  getResources().getString(R.string.Server_error), Toast.LENGTH_SHORT).show();
            } else if(msg.what == Variable.SOCKET_SVR_FIN){
                Bundle bundle = msg.getData();
                String[] strTotal = bundle.getStringArray("Total");
                int[][] total = new int[34][22];
                for(int i=0 ; i < 34 ; ++i){
                    String[] tmp = strTotal[i].split("&");  // 0&0&0&0&0&0&0&0&0&0&0&0...&0 (共22) => 0 0 0 0 0 0 0 0 0 0 0 0 ... 0 (共22)
                    for(int j=0 ; j < 22 ; ++j){
                        total[i][j] = Integer.valueOf(tmp[j]);
                    }
                }

                final String[] words = getResources().getStringArray(R.array.BarWords);
                final String[] ratio = data.getString("Ratio").split("\\+");
                final float[] ratioFloat = getRatioFloat(ratio);
//                int[] highlightIndex = getHighlightIndex(ratioFloat);    // 取得高亮目標，判斷該筆資料區間
                int[] highlightIndex = new int[34];
                int idx = 0;
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],2f,4f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],2f,4f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,2f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,1f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,1f);

                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,1f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);

                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,25f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,30f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],15f,40f);

                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,10f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,20f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.1f);

                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,10f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,1.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,4f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],60f,200f);

                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,2f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,0.5f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,1f);

                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,10f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,10f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx++],0f,4f);
                highlightIndex[idx] = getHighLightIndex(ratioFloat[idx],0f,0.5f);
                if(data.getString("From").equals("WaitAnimation"))
                    sendTotalToServer(highlightIndex);

                for(int i=0 ; i < 34 ; ++i){
                    total[i] = new int[]{
                            (int)(Math.random()*1.1),
                            (int)(Math.random()*1.2),
                            (int)(Math.random()*2),
                            (int)(Math.random()*2),
                            (int)(Math.random()*10)+3,
                            (int)(Math.random()*10)+3,
                            (int)(Math.random()*15)+4,
                            (int)(Math.random()*30)+5,
                            (int)(Math.random()*30)+5,
                            (int)(Math.random()*40)+6,
                            (int)(Math.random()*50)+7,
                            (int)(Math.random()*50)+7,
                            (int)(Math.random()*40)+6,
                            (int)(Math.random()*30)+5,
                            (int)(Math.random()*30)+5,
                            (int)(Math.random()*15)+4,
                            (int)(Math.random()*10)+3,
                            (int)(Math.random()*10)+3,
                            (int)(Math.random()*2),
                            (int)(Math.random()*2),
                            (int)(Math.random()*1.2),
                            (int)(Math.random()*1.1)
                    };
                }

                for(int i= 0 ; i < 34 ; ++i)
                    ++total[i][highlightIndex[i]];


                getChartView(words[2],1.0f,2.0f,total[2],highlightIndex[2]);   // 臉長寬比
                getChartView(words[3],0.2f,0.4f,total[3],highlightIndex[3]);   // 上庭比例
                getChartView(words[4],0.2f,0.4f,total[4],highlightIndex[4]);   // 中庭比例
                getChartView(words[5],0.2f,0.4f,total[5],highlightIndex[5]);   // 下庭比例
                getChartView(words[6],0.1f,0.3f,total[6],highlightIndex[6]);   // 五眼－右眼外側比例
                getChartView(words[7],0.1f,0.3f,total[7],highlightIndex[7]);   // 五眼－右眼比例
                getChartView(words[8],0.1f,0.3f,total[8],highlightIndex[8]);   // 五眼－兩眼內側比例
                getChartView(words[9],0.1f,0.3f,total[9],highlightIndex[9]);   // 五眼－左眼比例
                getChartView(words[10],0.1f,0.3f,total[10],highlightIndex[10]);// 五眼－左眼外側比例
                getChartView(words[11],0,0.5f,total[11],highlightIndex[11]);   // 額頭高度比臉長
                getChartView(words[15],3,8,total[15],highlightIndex[15]);      // 眉毛寬度除以厚度
                getChartView(words[23],1,4,total[23],highlightIndex[23]);      // 眼寬除以眼高
                getChartView(words[28],0.1f,0.2f,total[28],highlightIndex[28]);// 人中長度比臉寬
                getChartView(words[30],0.3f,0.8f,total[30],highlightIndex[30]);// 嘴唇寬度比眼寬

            }
        }
    };
    //endregion

    private Bitmap originFake;
    private int transX;
    private int transY;
    private void setPointData(){
        final String[] pointX = data.getStringArray("pointX");
        final String[] pointY = data.getStringArray("pointY");

        for(int i=0 ; i < 148 ; ++i){
            allPoint[i] = new Point(
                    Integer.valueOf(pointX[i]),
                    Integer.valueOf(pointY[i]));
        }

        // 107版本
//        // 左邊眉毛
//        EyebrowLeftTopPoint = allPoint[29];     // 左眉上緣點
//        EyebrowLeftDownPoint = allPoint[34];    // 左眉下緣點
//        EyebrowLeftLeftPoint = allPoint[27];    // 左眉左緣點
//        EyebrowLeftRightPoint = allPoint[32];   // 左眉右緣點
//        // 右邊眉毛
//        EyebrowRightTopPoint = allPoint[21];    // 右眉上緣點
//        EyebrowRightDownPoint = allPoint[25];   // 右眉下緣點
//        EyebrowRightLeftPoint = allPoint[18];   // 右眉左緣點
//        EyebrowRightRightPoint = allPoint[23];  // 右眉右緣點
//        // 左邊眼睛
//        EyeLeftTopPoint = allPoint[58];    //左眼上緣點
//        EyeLeftDownPoint = allPoint[62];   //左眼下緣點
//        EyeLeftLeftPoint = allPoint[56];   //左眼左緣點
//        EyeLeftRightPoint = allPoint[60];  //左眼右緣點
//        // 右邊眼睛
//        EyeRightTopPoint = allPoint[49];   //右眼上緣點
//        EyeRightDownPoint = allPoint[54];  //右眼下緣點
//        EyeRightLeftPoint = allPoint[47];  //右眼左緣點
//        EyeRightRightPoint = allPoint[51]; //右眼右緣點
//        // 鼻子
//        NoseLeftPoint = allPoint[42];      //鼻子左點
//        NoseRightPoint = allPoint[45];     //鼻子右點
//        NoseLowPoint = allPoint[44];       //鼻子底點
//        // 嘴唇
//        LipsLeftPoint = allPoint[71];      //嘴唇左緣點
//        LipsRightPoint = allPoint[65];     //嘴唇右緣點
//        UpLipThickness = allPoint[79].y - allPoint[68].y;   //上唇厚度
//        DownLipThickness = allPoint[75].y - allPoint[82].y; //下唇厚度
//        MouthLeftPoint = allPoint[65];     //嘴唇左點
//        MouthRightPoint = allPoint[71];    //嘴唇右點
//        MouthPeak = allPoint[69];          //唇峰
//        MouthValley = allPoint[68];        //唇谷
//        // 臉
//        FaceTopPoint = allPoint[98];       //臉上緣點
//        FaceLowPoint = allPoint[96];       //臉下緣點
//        FaceLeftPoint = allPoint[11];      //臉左緣點
//        FaceRightPoint = allPoint[1];      //臉右緣點
//        FaceWidth = allPoint[11].x - allPoint[1].x;   //臉寬
//        FaceHeight = FaceLowPoint.y - FaceTopPoint.y; //臉高
//        // 其他數據
//        EyebrowToChin = FaceLowPoint.y - ((EyebrowRightLeftPoint.y + EyebrowLeftRightPoint.y) / 2);//眉毛到下巴距離
//        NoseWidth = NoseRightPoint.x - NoseLeftPoint.x;     // 鼻子寬度
//        MouthWidth = MouthRightPoint.x - MouthLeftPoint.x;  // 嘴巴寬度
//        // 比例  五眼
//        FiveEyeRightEyeOuter = ((double)(allPoint[47].x - allPoint[1].x) / (allPoint[11].x - allPoint[1].x));//右眼尾至髮際線比例
//        FiveEyeRightEyeInner = ((double)(allPoint[51].x - allPoint[47].x) / (allPoint[11].x - allPoint[1].x));//右眼頭至眼尾比例
//        FiveEyeCenter = ((double)(allPoint[56].x - allPoint[51].x) / (allPoint[11].x - allPoint[1].x));//兩眼頭間比例
//        FiveEyeLeftEyeInner = ((double)(allPoint[60].x - allPoint[56].x) / (allPoint[11].x - allPoint[1].x));//左眼頭至眼尾比例
//        FiveEyeLeftEyeOuter = 1.0 - FiveEyeRightEyeOuter - FiveEyeRightEyeInner - FiveEyeCenter - FiveEyeLeftEyeInner;
//
//        FiveEyeRightEyeOuter = Math.round(FiveEyeRightEyeOuter*100);
//        FiveEyeRightEyeInner = Math.round(FiveEyeRightEyeInner*100);
//        FiveEyeCenter = Math.round(FiveEyeCenter*100);
//        FiveEyeLeftEyeInner = Math.round(FiveEyeLeftEyeInner*100);
//        FiveEyeLeftEyeOuter = Math.round(FiveEyeLeftEyeOuter*100);
//        // 比例 三庭
//        ThreeCourtTop = Math.round((double)(allPoint[34].y - allPoint[98].y) / (allPoint[96].y - allPoint[98].y)*100);
//        ThreeCourtCenter = Math.round((double)(allPoint[44].y - allPoint[34].y) / (allPoint[96].y - allPoint[98].y)*100);
//        ThreeCourtLow = Math.round((double)(allPoint[96].y - allPoint[44].y) / (allPoint[96].y - allPoint[98].y)*100);
//        // 四端點，用來縮進
//        mostRightPoint = Math.round((float)(FaceLeftPoint.x + FaceWidth / 6));
////        mostRightPoint = allPoint[86].x;
//        mostTopPoint = FaceTopPoint.y;
//        mostBotPoint = FaceLowPoint.y;
////        mostLeftPoint = EyeRightRightPoint.x;
//        mostLeftPoint = allPoint[86].x;

        // 122版本
        // 左邊眉毛 (圖片右)












//////////////////////////////////////////////////////////////////////////////////參數
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
        FaceWidth = allPoint[24].x - allPoint[1].x;   //臉寬
        FaceHeight = allPoint[123].y - allPoint[125].y;     //臉高

        transX = allPoint[113].x - FaceWidth/10;
        transY = allPoint[125].y - FaceHeight/5;
        if(transX <= 0 ) transX = 1;
        if(transY <= 0) transY = 1;

        // 移動座標點到裁減過後的位置
        for(int i=0 ; i < 148 ; ++i)
            allPoint[i] = new Point(allPoint[i].x - transX,allPoint[i].y - transY);


        // 左右均為圖片左右
        EyebrowLeftTopPoint = allPoint[48];     // 左眉上緣點
        EyebrowLeftDownPoint = allPoint[52];    // 左眉下緣點
        EyebrowLeftLeftPoint = allPoint[45];    // 左眉左緣點
        EyebrowLeftRightPoint = allPoint[50];   // 左眉右緣點
        // 右邊眉毛
        EyebrowRightTopPoint = allPoint[56];    // 右眉上緣點
        EyebrowRightDownPoint = allPoint[61];   // 右眉下緣點
        EyebrowRightLeftPoint = allPoint[54];   // 右眉左緣點
        EyebrowRightRightPoint = allPoint[59];  // 右眉右緣點
        // 左邊眼睛
        EyeLeftTopPoint = allPoint[76];    //左眼上緣點
        EyeLeftDownPoint = allPoint[81];   //左眼下緣點
        EyeLeftLeftPoint = allPoint[74];   //左眼左緣點
        EyeLeftRightPoint = allPoint[78];  //左眼右緣點
        // 右邊眼睛
        EyeRightTopPoint = allPoint[85];   //右眼上緣點
        EyeRightDownPoint = allPoint[89];  //右眼下緣點
        EyeRightLeftPoint = allPoint[83];  //右眼左緣點
        EyeRightRightPoint = allPoint[87]; //右眼右緣點
        // 鼻子
        NoseLeftPoint = allPoint[69];      //鼻子左點
        NoseRightPoint = allPoint[72];     //鼻子右點
        NoseLowPoint = allPoint[71];       //鼻子底點
        // 嘴唇
        LipsLeftPoint = allPoint[92];      //嘴唇左緣點
        LipsRightPoint = allPoint[98];     //嘴唇右緣點
        UpLipThickness = allPoint[106].y - allPoint[95].y;   //上唇厚度
        DownLipThickness = allPoint[102].y - allPoint[109].y; //下唇厚度
        MouthLeftPoint = allPoint[92];     //嘴唇左點
        MouthRightPoint = allPoint[98];    //嘴唇右點
        MouthPeak = allPoint[96].y > allPoint[93].y? allPoint[96] : allPoint[93];          //唇峰
        MouthValley = allPoint[95];        //唇谷
        // 臉
        FaceTopPoint = allPoint[125];       //臉上緣點
        FaceLowPoint = allPoint[123];       //臉下緣點
        FaceLeftPoint = allPoint[1];      //臉左緣點
        FaceRightPoint = allPoint[24];      //臉右緣點

        // 其他數據
        EyebrowToChin = FaceLowPoint.y - ((EyebrowRightLeftPoint.y + EyebrowLeftRightPoint.y) / 2);//眉毛到下巴距離
        NoseWidth = NoseRightPoint.x - NoseLeftPoint.x;     // 鼻子寬度
        MouthWidth = MouthRightPoint.x - MouthLeftPoint.x;  // 嘴巴寬度
        // 比例  五眼
        FiveEyeRightEyeOuter = ((double)(allPoint[24].x - allPoint[87].x) / FaceWidth);   //右眼尾至臉邊緣比例
        FiveEyeRightEyeInner = ((double)(allPoint[87].x - allPoint[83].x) / FaceWidth);  //右眼頭至眼尾比例
        FiveEyeCenter = ((double)(allPoint[83].x - allPoint[78].x) / FaceWidth);         //兩眼頭間比例
        FiveEyeLeftEyeInner = ((double)(allPoint[78].x - allPoint[74].x) / FaceWidth);   //左眼頭至眼尾比例
        FiveEyeLeftEyeOuter = 1.0 - FiveEyeRightEyeOuter - FiveEyeRightEyeInner - FiveEyeCenter - FiveEyeLeftEyeInner;

        FiveEyeRightEyeOuter = Math.round(FiveEyeRightEyeOuter*100);
        FiveEyeRightEyeInner = Math.round(FiveEyeRightEyeInner*100);
        FiveEyeCenter = Math.round(FiveEyeCenter*100);
        FiveEyeLeftEyeInner = Math.round(FiveEyeLeftEyeInner*100);
        FiveEyeLeftEyeOuter = Math.round(FiveEyeLeftEyeOuter*100);
        // 比例 三庭
        Point midEyeBrow = new Point((allPoint[52].x + allPoint[61].x)/2,(allPoint[52].y + allPoint[61].y)/2); // 兩眉毛下緣平均高度
        ThreeCourtTop = Math.round((double)(midEyeBrow.y - allPoint[125].y) / FaceHeight * 100);
        ThreeCourtCenter = Math.round((double)(allPoint[71].y - midEyeBrow.y) / FaceHeight * 100);
        ThreeCourtLow = Math.round((double)(allPoint[123].y - allPoint[71].y) / FaceHeight * 100);
        // 四端點，用來縮進
        mostRightPoint = allPoint[118].x;
        mostTopPoint = allPoint[125].y;
        mostBotPoint = allPoint[123].y;
        mostLeftPoint = allPoint[113].x;
    }
    private void setPanelData(){
        ImageView imageView;
        Bitmap srcBitmap = Variable.srcBitmap;

        int LeftP = mostLeftPoint - FaceWidth/10 + transX;
        int TopP = mostTopPoint - FaceHeight/5 + transY;
        int RightP = mostRightPoint + FaceWidth/10 + transX;
        int BottomP = mostBotPoint + FaceHeight/6 + transY;
        int Width = RightP - LeftP;
        int Height = BottomP - TopP;
        if(LeftP <= 0 ) LeftP = 1;
        if(TopP <= 0) TopP = 1;
        if(LeftP + Width > srcBitmap.getWidth()) Width = srcBitmap.getWidth() - LeftP;
        if(TopP + Height > srcBitmap.getHeight()) Height = srcBitmap.getHeight() - TopP;

        // 移動座標點到裁減過後的位置
//        for(int i=0 ; i < 122 ; ++i)
//            allPoint[i] = new Point(allPoint[i].x - LeftP,allPoint[i].y - TopP);


        cropBitmap = Bitmap.createBitmap(srcBitmap,LeftP,TopP,Width,Height,null,true);


        imageView = new ImageView(this);
        imageView.setImageBitmap(drawBasic(cropBitmap));
        ivList.add(imageView);

        imageView = new ImageView(this);
        originFake = Bitmap.createBitmap(cropBitmap.getWidth(),cropBitmap.getHeight(), Bitmap.Config.ARGB_8888);
        imageView.setImageBitmap(drawPointAndLine(originFake,cropBitmap));
        ivList.add(imageView);

        imageView = new ImageView(this);
        originFake = Bitmap.createBitmap(cropBitmap.getWidth(),cropBitmap.getHeight(), Bitmap.Config.ARGB_8888);
        imageView.setImageBitmap(drawCartoon(originFake,cropBitmap));
        ivList.add(imageView);

        allPoint[71].x += transX;   // 取對稱點，先暫時移回原始位置



        allPoint[71].x -= transX;   // 取完對稱點，移回修改後的位置

        // 灰階測試
//        imageView = new ImageView(this);
//        Bitmap grayBmp = gray(cropBitmap,255);
//        imageView.setImageBitmap(grayBmp);
//        ivList.add(imageView);


//        imageView = new ImageView(this);



        originFake = Bitmap.createBitmap(cropBitmap.getWidth(),cropBitmap.getHeight(), Bitmap.Config.ARGB_8888);
//        originFake = cropBitmap.copy(Bitmap.Config.ARGB_8888,true);
        drawFake(originFake,cropBitmap);
//        originFake = Bitmap.createBitmap(fakeBmp,LeftP,TopP,Width,Height,null,true);
//        originFake = fakeBmp;


        Message msg = Message.obtain();
        Bundle bundle = new Bundle();
        bundle.putParcelable("scaledFake",originFake);
        msg.setData(bundle);
        msg.what = 0;
        viewHandler.sendMessage(msg);


//        setComment(originFake,"msgCommentsFace",FACE);
        setComment(originFake,"msgCommentsEyeBrows",EYEBROWS);
        setComment(originFake,"msgCommentsEye",EYE);
        setComment(originFake,"msgCommentsNose",NOSE);
        setComment(originFake,"msgCommentsLips",LIPS);
//        setComment(originFake,"msgCommentsForeHead",FOREHEAD);
        setComment(originFake,"msgCommentsChin",CHIN);
    }
    private void setAdapter(){
        MyAdapter adapter = new MyAdapter();
        vpResult.setAdapter(adapter);
        circlePageIndicator.setViewPager(vpResult);
        vpResult.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {}

            @Override
            public void onPageSelected(int position) {
                if(position == 0)
                    tvMark.setText("比例分析");
                else if(position == 1)
                    tvMark.setText("");
                else if(position == 2)
                    tvMark.setText("");
            }

            @Override
            public void onPageScrollStateChanged(int state) {}
        });
    }
    private void setComment(Bitmap bitmap,String keyComment,int mode){
        StringBuilder comment = new StringBuilder();
        if(mode == CHIN) {
            comment.append(data.getString("msgCommentsFace"));
            comment.append(System.lineSeparator());
            comment.append(data.getString("msgCommentsForeHead"));
            comment.append(System.lineSeparator());
            comment.append(data.getString(keyComment));
        }else
            comment.append(data.getString(keyComment));
//        if(comment == null) return;

        Message msg = Message.obtain();
        Bundle bundle = new Bundle();

        switch(mode) {
            case FACE:
                bundle.putParcelable("Bitmap",drawFakeFace(bitmap));
                break;
            case EYEBROWS:
                bundle.putParcelable("Bitmap",drawFakeEyeBrow(bitmap));
                break;
            case EYE:
                bundle.putParcelable("Bitmap",drawFakeEyes(bitmap));
                break;
            case NOSE:
                bundle.putParcelable("Bitmap",drawFakeNose(bitmap));
                break;
            case LIPS:
                bundle.putParcelable("Bitmap",drawFakeLips(bitmap));
                break;
            case FOREHEAD:
                bundle.putParcelable("Bitmap",drawFakeForeHead(bitmap));
                break;
            case CHIN:
                bundle.putParcelable("Bitmap",drawFakeChin(bitmap));
                break;
            default:
                // do nothing
        }
        bundle.putString("Comment",comment.toString());
        msg.setData(bundle);
        msg.what = mode;
        viewHandler.sendMessage(msg);
    }
    private Bitmap drawFakeFace(Bitmap src){
        Bitmap bmp = src.copy(Bitmap.Config.ARGB_8888,true);
        Canvas canvas = new Canvas(bmp);
        int width = FaceWidth;
        int height = FaceHeight;

        /*
        Paint SolidLineGreen = newPaintLine("#00ff00",(float)FaceWidth/50, Paint.Style.STROKE);
        Paint SolidLineRed = newPaintLine("#ff0000",(float)FaceWidth/30, Paint.Style.STROKE);
        Paint ArrowGreen = newPaintLine("#00ff00",(float)width/50, Paint.Style.FILL);
        */
        Paint SolidLineGreen = newPaintLine("#007300",(float)FaceWidth/30, Paint.Style.STROKE);
        Paint SolidLineRed = newPaintLine("#007300",(float)FaceWidth/30, Paint.Style.STROKE);
        Paint ArrowGreen = newPaintLine("#007300",(float)width/50, Paint.Style.FILL);

        drawTria(canvas,allPoint[24].x,allPoint[24].y,allPoint[1].x,allPoint[1].y,width/15,width/15,SolidLineGreen,ArrowGreen);
        drawTria(canvas,allPoint[125].x,allPoint[125].y,allPoint[123].x,allPoint[123].y,width/15,width/15,SolidLineGreen,ArrowGreen);

        Point pointOne;
        Point pointTwo;
        int theLen = FaceWidth*2/5;
        // 圖右臉部斜率 29 27
        double ratio = ((double)(allPoint[39].y - allPoint[41].y)/(allPoint[39].x - allPoint[41].x));
        double degree = Math.atan(ratio);
        Point mid = new Point((allPoint[39].x + allPoint[41].x)/2,(allPoint[39].y + allPoint[41].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,SolidLineRed);
        // 圖右下巴斜率 30 32
        ratio = ((double)(allPoint[42].y - allPoint[44].y)/(allPoint[42].x - allPoint[44].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[42].x + allPoint[44].x)/2,(allPoint[42].y + allPoint[44].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,SolidLineRed);
        // 圖左下巴斜率 78 100
        ratio = ((double)(allPoint[90].y - allPoint[112].y)/(allPoint[90].x - allPoint[112].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[90].x + allPoint[112].x)/2,(allPoint[90].y + allPoint[112].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,SolidLineRed);
        // 圖左臉部斜率 45 67
        ratio = ((double)(allPoint[57].y - allPoint[79].y)/(allPoint[57].x - allPoint[79].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[57].x + allPoint[79].x)/2,(allPoint[57].y + allPoint[79].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,SolidLineRed);

        return bmp;
    }
    private Bitmap drawFakeForeHead(Bitmap src){
        //107: 23 27 & 96 & 98
        //122: 38 42 & 111 & 113
        Bitmap bmp = src.copy(Bitmap.Config.ARGB_8888,true);
        Canvas canvas = new Canvas(bmp);

        Paint SolidLineRed = newPaintLine("#007300",(float)FaceWidth/30, Paint.Style.STROKE);
        Paint ArrowRed = newPaintLine("#007300",(float)FaceWidth/30, Paint.Style.FILL);

        Point mid = new Point((allPoint[50].x + allPoint[54].x)/2,(allPoint[50].y + allPoint[54].y)/2);

        drawTria(canvas,allPoint[125].x,allPoint[125].y,allPoint[125].x,mid.y, FaceWidth/15,FaceWidth/15,SolidLineRed,ArrowRed);
        drawTria(canvas,allPoint[125].x,allPoint[123].y,allPoint[125].x,mid.y, FaceWidth/15,FaceWidth/15,SolidLineRed,ArrowRed);

        return bmp;
    }
    private Bitmap drawFakeNose(Bitmap src){
        //107: 23 27 && 42 & 45
        //122: 38 42 & 57 & 60
        /*
        Bitmap bmp = Bitmap.createBitmap(src.getWidth(),src.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bmp);
        canvas.drawARGB(0,0,0,0);
        */
        Bitmap source = src.copy(Bitmap.Config.ARGB_8888,true);
        Bitmap output = Bitmap.createBitmap(source.getWidth(), source.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setColor(0XFF000000);
        ArrayList<Point> points = new ArrayList<>();
        Path nosePath = new Path();
        Path righteyePath = new Path();
        Path lefteyePath = new Path();
        Path all = new Path();

        points.add(allPoint[83]); points.add(allPoint[91]); points.add(allPoint[89]); points.add(allPoint[88]);
        points.add(allPoint[87]); points.add(allPoint[86]); points.add(allPoint[85]); points.add(allPoint[84]);
        points.add(allPoint[83]); points.add(allPoint[91]);

        righteyePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            righteyePath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);

        }
        points.clear();

        points.add(allPoint[74]); points.add(allPoint[82]); points.add(allPoint[81]); points.add(allPoint[80]);
        points.add(allPoint[78]); points.add(allPoint[77]); points.add(allPoint[76]); points.add(allPoint[75]);
        points.add(allPoint[74]); points.add(allPoint[82]);

        lefteyePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            lefteyePath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }
        points.clear();

        points.add(allPoint[69]); points.add(allPoint[70]); points.add(allPoint[18]); points.add(allPoint[71]);
        points.add(allPoint[19]); points.add(allPoint[73]); points.add(allPoint[72]); points.add(allPoint[66]);
        points.add(allPoint[17]); points.add(allPoint[64]); points.add(allPoint[63]); points.add(allPoint[16]);
        points.add(allPoint[65]); points.add(allPoint[69]);

        nosePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            nosePath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }
        points.clear();

        righteyePath.op(lefteyePath,Path.Op.UNION);
        righteyePath.op(nosePath, Path.Op.UNION);
        canvas.drawPath(righteyePath, paint);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(src, 0, 0, paint);



        int width = allPoint[87].x - allPoint[74].x + FaceWidth/30;
        Point high = allPoint[96].y < allPoint[85].y ? allPoint[96] : allPoint[85];
        int height = allPoint[71].y - high.y + FaceWidth/30;

        /*
        Paint SolidLineRed = newPaintLine("#ff0000",(float)width/60, Paint.Style.STROKE);
        Paint SolidLineGreen = newPaintLine("#00ff00",(float)width/60, Paint.Style.STROKE);
        Paint ArrowRed = newPaintLine("#ff0000",(float)width/50, Paint.Style.FILL);
        Paint ArrowGreen = newPaintLine("#00ff00",(float)width/50, Paint.Style.FILL);
        Paint wordGreen = newWordPaint("#00c900",width/8);
        Paint wordRed = newWordPaint("#ff0000",width/8);

        Paint skinPaint = newPaintLine("#ffcea3",(float)FaceWidth/200, Paint.Style.FILL);
        Paint nosePaint = newPaintLine("#eaa161",(float)FaceWidth/100, Paint.Style.STROKE);

        Paint blackPaint = newPaintLine("#000000",(float)FaceWidth/200, Paint.Style.FILL);
        Paint whitePaint = newPaintLine("#ffffff",(float)FaceWidth/200, Paint.Style.FILL);
        Paint eyeLidPaint = newPaintLine("#3e3b40",(float)FaceWidth/100, Paint.Style.STROKE);
*/
        Paint SolidLineRed = newPaintLine("#007300",(float)width/60, Paint.Style.STROKE);
        Paint SolidLineGreen = newPaintLine("#007300",(float)width/60, Paint.Style.STROKE);
        Paint ArrowRed = newPaintLine("#ff0000",(float)width/90, Paint.Style.FILL);
        Paint ArrowGreen = newPaintLine("#ff0000",(float)width/90, Paint.Style.FILL);
        Paint wordGreen = newWordPaint("#007300",width/8);
        Paint wordRed = newWordPaint("#007300",width/8);

        Paint skinPaint = newPaintLine("#ff0000",(float)FaceWidth/200, Paint.Style.FILL);
        Paint nosePaint = newPaintLine("#ff0000",(float)FaceWidth/100, Paint.Style.STROKE);

        Paint blackPaint = newPaintLine("#ff0000",(float)FaceWidth/200, Paint.Style.FILL);
        Paint whitePaint = newPaintLine("#ff0000",(float)FaceWidth/200, Paint.Style.FILL);
        Paint eyeLidPaint = newPaintLine("#ff0000",(float)FaceWidth/100, Paint.Style.STROKE);
        //ArrayList<Point> points = new ArrayList<>();
        /*
        // 左眼
        points.add(allPoint[62]); points.add(allPoint[63]); points.add(allPoint[64]); points.add(allPoint[65]);
        points.add(allPoint[66]); points.add(allPoint[68]); points.add(allPoint[69]); points.add(allPoint[70]);
        drawCurve(canvas,points,whitePaint,true);
        points.clear();
        // 右眼
        points.add(allPoint[71]); points.add(allPoint[72]); points.add(allPoint[73]); points.add(allPoint[74]);
        points.add(allPoint[75]); points.add(allPoint[76]); points.add(allPoint[77]); points.add(allPoint[79]);
        drawCurve(canvas,points,whitePaint,true);
        points.clear();

        Path path = new Path();
        // 左眼球
        path.addCircle((allPoint[64].x+allPoint[69].x)/2,(allPoint[64].y+allPoint[69].y)/2,(allPoint[69].y-allPoint[64].y)/2,Path.Direction.CW);
        canvas.drawPath(path,blackPaint);
        path.reset();
        // 右眼球
        path.addCircle((allPoint[73].x+allPoint[77].x)/2,(allPoint[73].y+allPoint[77].y)/2,(allPoint[77].y-allPoint[73].y)/2,Path.Direction.CW);
        canvas.drawPath(path,blackPaint);
        path.reset();
        // 鼻子
        points.add(allPoint[51]); points.add(allPoint[16]); points.add(allPoint[53]); points.add(allPoint[57]);
        points.add(allPoint[58]); points.add(allPoint[18]); points.add(allPoint[59]); points.add(allPoint[19]);
        points.add(allPoint[61]); points.add(allPoint[60]); points.add(allPoint[54]); points.add(allPoint[17]);
        points.add(allPoint[52]);
        drawCurve(canvas,points,skinPaint,true);
        drawCurve(canvas,points,nosePaint,false);
        points.clear();
        */
        // 兩眼連線
        drawTria(canvas,allPoint[83].x,allPoint[83].y,allPoint[78].x,allPoint[78].y,width/20,width/25,SolidLineGreen,SolidLineGreen);
        canvas.drawText((allPoint[83].x-allPoint[78].x)+"",(allPoint[83].x+allPoint[78].x)/2,allPoint[78].y+height/5,wordGreen);

        // 鼻子連線
        drawTria(canvas,allPoint[69].x,allPoint[69].y,allPoint[72].x,allPoint[69].y,width/20,width/25,SolidLineRed,SolidLineRed);
        canvas.drawText((allPoint[72].x-allPoint[69].x)+"",(allPoint[69].x+allPoint[72].x)/2,allPoint[69].y-height/10,wordRed);

        output = Bitmap.createBitmap(output,allPoint[74].x - FaceWidth/70,high.y - FaceWidth/70,width,height,null,true);

        return output;
    }
    private Bitmap drawFakeLips(Bitmap src){
        //107: 68 & 75 & 79+82   && 65 & 71
        //122: 83 & 90 & 94+97 & 80 & 86
        //Bitmap bmp = Bitmap.createBitmap(src.getWidth(),src.getHeight(), Bitmap.Config.ARGB_8888);
        //Canvas canvas = new Canvas(bmp);
        Bitmap source = src.copy(Bitmap.Config.ARGB_8888,true);
        Bitmap output = Bitmap.createBitmap(source.getWidth(), source.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setColor(0XFF000000);
        ArrayList<Point> points = new ArrayList<>();
        Path mouthPath = new Path();
        Point mid;

        points.add(allPoint[92]);points.add(allPoint[94]);points.add(allPoint[93]);points.add(allPoint[95]);
        points.add(allPoint[96]);points.add(allPoint[97]);points.add(allPoint[98]);points.add(allPoint[99]);
        points.add(allPoint[100]);points.add(allPoint[102]);points.add(allPoint[103]);points.add(allPoint[104]);
        points.add(allPoint[92]);

        mouthPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            if (i == 0 || i == 5 || i == 6 || i == 7 || i == 11 || i == 12){
                Point p1 = points.get(i);
                Point p2 = points.get(i + 1);
                int w = Math.abs(p2.x - p1.x);
                int h = Math.abs(p2.y - p1.y);
                mid = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);

                if (p2.x >= p1.x)
                    mouthPath.quadTo(mid.x, mid.y + h / 4, p2.x, p2.y);
                else
                    mouthPath.quadTo(mid.x, mid.y - h / 4, p2.x, p2.y);
            }
            else {
                Point p1 = points.get(i);
                Point p2 = points.get(i+1);
                Point p3 = points.get(i+2);
                mouthPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
            }
        }

        canvas.drawPath(mouthPath, paint);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(src, 0, 0, paint);


        //canvas.drawARGB(0,0,0,0);
        points.clear();
        Point high = allPoint[93].y > allPoint[96].y? allPoint[93] : allPoint[96];
        int width = allPoint[98].x - allPoint[92].x + FaceWidth/30;
        int height = allPoint[102].y - high.y + FaceWidth/30;

        /*
        Paint SolidLineRed = newPaintLine("#ff0000",(float)width/70, Paint.Style.STROKE);
        Paint SolidLineGreen = newPaintLine("#00ff00",(float)width/70, Paint.Style.STROKE);
        Paint ArrowRed = newPaintLine("#ff0000",(float)width/50, Paint.Style.FILL);
        Paint ArrowGreen = newPaintLine("#00ff00",(float)width/50, Paint.Style.FILL);
        Paint wordRed = newWordPaint("#ffffff",width/8);
        Paint wordGreen = newWordPaint("#95ff00",width/9);

        Paint lipPaint = newPaintLine("#e65d62",(float)FaceWidth/200, Paint.Style.FILL);
        Paint lipLinePaint = newPaintLine("#533130",(float)FaceWidth/100, Paint.Style.STROKE);
        */
        Paint SolidLineRed = newPaintLine("#007300",(float)width/60, Paint.Style.STROKE);
        Paint SolidLineGreen = newPaintLine("#007300",(float)width/60, Paint.Style.STROKE);
        Paint ArrowRed = newPaintLine("#ff0000",(float)width/90, Paint.Style.FILL);
        Paint ArrowGreen = newPaintLine("#ff0000",(float)width/90, Paint.Style.FILL);
        Paint wordRed = newWordPaint("#007300",width/8);
        Paint wordGreen = newWordPaint("#007300",width/9);

        Paint lipPaint = newPaintLine("#ff0000",(float)FaceWidth/200, Paint.Style.FILL);
        Paint lipLinePaint = newPaintLine("#ff0000",(float)FaceWidth/100, Paint.Style.STROKE);
/*
        ArrayList<Point> points = new ArrayList<>();
        // 嘴唇(外)
        points.add(allPoint[80]); points.add(allPoint[82]); points.add(allPoint[81]); points.add(allPoint[83]);
        points.add(allPoint[84]); points.add(allPoint[85]); points.add(allPoint[86]); points.add(allPoint[87]);
        points.add(allPoint[88]); points.add(allPoint[90]); points.add(allPoint[91]); points.add(allPoint[92]);
        drawCurve(canvas,points,lipPaint,true);
        points.clear();
        // 嘴唇線
        points.add(allPoint[80]); points.add(allPoint[98]); points.add(allPoint[97]);
        points.add(allPoint[96]); points.add(allPoint[86]);
        drawCurve(canvas,points,lipLinePaint,false);
        points.clear();
*/
        //122: 83 & 97 & 90
        drawTria(canvas,allPoint[95].x,allPoint[95].y,allPoint[109].x,allPoint[109].y,width/20,width/25,SolidLineGreen,SolidLineGreen);
        drawTria(canvas,allPoint[109].x,allPoint[109].y,allPoint[102].x,allPoint[102].y,width/20,width/25,SolidLineGreen,SolidLineGreen);
        canvas.drawText((allPoint[109].y-allPoint[95].y)+"",allPoint[109].x+width/8,allPoint[109].y-height/10,wordGreen);
        canvas.drawText((allPoint[102].y-allPoint[109].y)+"",allPoint[109].x+width/8,allPoint[109].y+height/3,wordGreen);

        //122: 80-86 水平紅線
        drawTria(canvas,allPoint[92].x,high.y,allPoint[98].x,high.y,width/20,width/25,SolidLineRed,SolidLineRed);
        canvas.drawText((allPoint[98].x-allPoint[92].x)+"",allPoint[92].x+width/10,high.y+height/4,wordRed);

        output = Bitmap.createBitmap(output,allPoint[92].x - FaceWidth/70,high.y - FaceWidth/40,width,height,null,true);

        return output;
    }
    private Bitmap drawFakeEyes(Bitmap src){
        //Bitmap bmp = Bitmap.createBitmap(src.getWidth(),src.getHeight(), Bitmap.Config.ARGB_8888);
        //Canvas canvas = new Canvas(bmp);
        //canvas.drawARGB(0,0,0,0);
        Bitmap source = src.copy(Bitmap.Config.ARGB_8888,true);
        Bitmap output = Bitmap.createBitmap(source.getWidth(), source.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setColor(0XFF000000);
        ArrayList<Point> points = new ArrayList<>();
        Path righteyePath = new Path();
        Point mid;

        points.add(allPoint[83]); points.add(allPoint[91]); points.add(allPoint[89]); points.add(allPoint[88]);
        points.add(allPoint[87]); points.add(allPoint[86]); points.add(allPoint[85]); points.add(allPoint[84]);
        points.add(allPoint[83]); points.add(allPoint[91]);

        righteyePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            righteyePath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }

        canvas.drawPath(righteyePath, paint);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(src, 0, 0, paint);

        points.clear();


        int width = allPoint[87].x - allPoint[83].x + FaceWidth/30;
        int height = allPoint[89].y - allPoint[85].y + FaceWidth/30;
        /*
        Paint SolidLineYellow = newPaintLine("#fff200",(float)width/65, Paint.Style.STROKE);
        Paint ArrowYellow = newArrowPaint("#fff200",(float)width/50);
        Paint SolidLineGreen = newPaintLine("#00ff00",(float)width/65, Paint.Style.STROKE);
        Paint ArrowGreen = newArrowPaint("#00ff00",(float)width/50);
        Paint SolidLineRed = newPaintLine("#ff0000",(float)width/70, Paint.Style.STROKE);


        Paint blackPaint = newPaintLine("#000000",(float)FaceWidth/200, Paint.Style.FILL);
        Paint whitePaint = newPaintLine("#ffffff",(float)FaceWidth/200, Paint.Style.FILL);
        Paint eyeLidPaint = newPaintLine("#3e3b40",(float)FaceWidth/100, Paint.Style.STROKE);
        */
        Paint SolidLineYellow = newPaintLine("#00DD00",(float)width/150, Paint.Style.STROKE);
        Paint ArrowYellow = newArrowPaint("#ff0000",(float)width/150);
        Paint SolidLineGreen = newPaintLine("#00DD00",(float)width/150, Paint.Style.STROKE);
        Paint ArrowGreen = newArrowPaint("#ff0000",(float)width/150);
        Paint SolidLineRed = newPaintLine("#00DD00",(float)width/150, Paint.Style.STROKE);


        Paint blackPaint = newPaintLine("#ff0000",(float)FaceWidth/200, Paint.Style.STROKE);
        Paint whitePaint = newPaintLine("#ff0000",(float)FaceWidth/200, Paint.Style.STROKE);
        Paint eyeLidPaint = newPaintLine("#ff0000",(float)FaceWidth/100, Paint.Style.STROKE);

        //ArrayList<Point> points = new ArrayList<>();
        // 右眼
        /*
        points.add(allPoint[71]); points.add(allPoint[72]); points.add(allPoint[73]); points.add(allPoint[74]);
        points.add(allPoint[75]); points.add(allPoint[76]); points.add(allPoint[77]); points.add(allPoint[79]);
        drawCurve(canvas,points,whitePaint,true);
        points.clear();
        Path path = new Path();
        path.addCircle((allPoint[73].x+allPoint[77].x)/2,(allPoint[73].y+allPoint[77].y)/2,(allPoint[77].y-allPoint[73].y)/2,Path.Direction.CW);
        canvas.drawPath(path,blackPaint);
        path.reset();
*/
        // 水平黃線
        drawTria(canvas,allPoint[83].x,allPoint[85].y,allPoint[87].x,allPoint[85].y,width/20,width/25,SolidLineYellow,SolidLineYellow);
        // 垂直綠線
        drawTria(canvas,allPoint[87].x,allPoint[85].y,allPoint[87].x,allPoint[89].y,width/20,width/25,SolidLineGreen,SolidLineGreen);

        // 內外眼角高低差 紅線
        canvas.drawLine(allPoint[83].x,allPoint[83].y,allPoint[83].x,allPoint[87].y,SolidLineRed);
        canvas.drawLine(allPoint[83].x - width/20,allPoint[83].y,allPoint[83].x + width/20,allPoint[83].y,SolidLineRed);
        canvas.drawLine(allPoint[83].x - width/20,allPoint[87].y,allPoint[83].x + width/20,allPoint[87].y,SolidLineRed);


        output = Bitmap.createBitmap(output,allPoint[83].x - FaceWidth/70,allPoint[85].y - FaceWidth/70,width,height,null,true);

        return output;
    }
    private Bitmap drawFakeEyeBrow(Bitmap src){
        /*
        Bitmap bmp = Bitmap.createBitmap(src.getWidth(),src.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bmp);
        canvas.drawARGB(0,0,0,0);
        */
        Bitmap source = src.copy(Bitmap.Config.ARGB_8888,true);
        Bitmap output = Bitmap.createBitmap(source.getWidth(), source.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setColor(0XFF000000);
        ArrayList<Point> points = new ArrayList<>();
        Path righteyebrowPath = new Path();
        Point mid;

        points.add(allPoint[54]); points.add(allPoint[55]); points.add(allPoint[56]); points.add(allPoint[58]);
        points.add(allPoint[59]); points.add(allPoint[60]); points.add(allPoint[61]); points.add(allPoint[54]); points.add(allPoint[55]);

        righteyebrowPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            righteyebrowPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }

        canvas.drawPath(righteyebrowPath, paint);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(src, 0, 0, paint);

        points.clear();


        int width = allPoint[59].x - allPoint[54].x + FaceWidth/20;
        int height = allPoint[61].y - allPoint[56].y + FaceWidth/20;
/*
        Paint SolidLineGreen = newPaintLine("#00ff00",(float)width/65, Paint.Style.STROKE);
        Paint SolidLineBlue = newPaintLine("#0000ff",(float)width/50, Paint.Style.STROKE);
        Paint SolidLineRed = newPaintLine("#ff0000",(float)width/65, Paint.Style.STROKE);

        Paint redWord = newWordPaint("#ff5900",width/10);
        Paint greenWord = newWordPaint("#00ff00",width/10);

        Paint ArrowRed = newArrowPaint("#ff0000",FaceWidth/200);

        Paint eyeBrowPaint = newPaintLine("#533130",(float)FaceWidth/200, Paint.Style.FILL);
        */
        Paint SolidLineGreen = newPaintLine("#007300",(float)width/60, Paint.Style.STROKE);
        Paint SolidLineBlue = newPaintLine("#00DD00",(float)width/80, Paint.Style.STROKE);
        Paint SolidLineRed = newPaintLine("#007300",(float)width/60, Paint.Style.STROKE);

        Paint redWord = newWordPaint("#007300",width/10);
        Paint greenWord = newWordPaint("#007300",width/10);

        Paint ArrowRed = newArrowPaint("#00DD00",FaceWidth/200);

        Paint eyeBrowPaint = newPaintLine("#00DD00",(float)FaceWidth/200, Paint.Style.FILL);
        //ArrayList<Point> points = new ArrayList<>();
        // 右眉毛
        /*
        points.add(allPoint[42]); points.add(allPoint[43]); points.add(allPoint[44]); points.add(allPoint[46]);
        points.add(allPoint[47]); points.add(allPoint[48]); points.add(allPoint[49]); points.add(allPoint[50]);
        drawCurve(canvas,points,eyeBrowPaint,true);
        points.clear();
*/
        // 29-34 (圖右眉 - 紅)
        drawTria(canvas,allPoint[56].x,allPoint[56].y,allPoint[61].x,allPoint[61].y,width/20, width/25, SolidLineRed,SolidLineRed);
        canvas.drawText((allPoint[61].y-allPoint[56].y)+"",allPoint[56].x+width/8,allPoint[54].y-height/10,redWord);

        // 27-32 (圖右眉 - 綠)
        drawTria(canvas,allPoint[54].x,allPoint[59].y,allPoint[59].x,allPoint[59].y,width/20, width/25, SolidLineGreen, SolidLineGreen);
        canvas.drawText((allPoint[59].x-allPoint[54].x)+"",allPoint[54].x+width/5,allPoint[54].y-height/12,greenWord);

        int a;
        a = allPoint[56].y - FaceWidth/70;
        if(a<0)
            a = 0;

        output = Bitmap.createBitmap(output,allPoint[54].x - FaceWidth/70,a,width,height,null,true);

        return output;
    }
    private Bitmap drawFakeChin(Bitmap src){
        // 63-96 & 96-15  && 98-44-96
        Bitmap bmp = src.copy(Bitmap.Config.ARGB_8888,true);
        Canvas canvas = new Canvas(bmp);
/*
        Paint SolidLineGreen = newPaintLine("#00ff00",(float)FaceWidth/40, Paint.Style.STROKE);
        Paint SolidLineRed = newPaintLine("#ff0000",(float)FaceWidth/40, Paint.Style.STROKE);
        Paint ArrowRed = newPaintLine("#ff0000",(float)FaceWidth/30, Paint.Style.FILL);
*/
        Paint SolidLineGreen = newPaintLine("#007300",(float)FaceWidth/40, Paint.Style.STROKE);
        Paint SolidLineRed = newPaintLine("#007300",(float)FaceWidth/40, Paint.Style.STROKE);
        Paint ArrowRed = newPaintLine("#007300",(float)FaceWidth/30, Paint.Style.FILL);
        Point pointOne;
        Point pointTwo;
        int theLen = FaceWidth*2/5;
        // 圖右臉部斜率 29 27
        double ratio = ((double)(allPoint[39].y - allPoint[41].y)/(allPoint[39].x - allPoint[41].x));
        double degree = Math.atan(ratio);
        Point mid = new Point((allPoint[39].x + allPoint[41].x)/2,(allPoint[39].y + allPoint[41].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,SolidLineRed);
        // 圖右下巴斜率 30 32
        ratio = ((double)(allPoint[42].y - allPoint[44].y)/(allPoint[42].x - allPoint[44].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[42].x + allPoint[44].x)/2,(allPoint[42].y + allPoint[44].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,SolidLineRed);
        // 圖左下巴斜率 78 100
        ratio = ((double)(allPoint[90].y - allPoint[112].y)/(allPoint[90].x - allPoint[112].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[90].x + allPoint[112].x)/2,(allPoint[90].y + allPoint[112].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,SolidLineRed);
        // 圖左臉部斜率 45 67
        ratio = ((double)(allPoint[57].y - allPoint[79].y)/(allPoint[57].x - allPoint[79].x));
        degree = Math.atan(ratio);
        mid = new Point((allPoint[57].x + allPoint[79].x)/2,(allPoint[57].y + allPoint[79].y)/2);
        pointOne = new Point((int)(mid.x + Math.cos(degree)*theLen),(int)(mid.y + Math.sin(degree)*theLen));
        pointTwo = new Point((int)(mid.x - Math.cos(degree)*theLen),(int)(mid.y - Math.sin(degree)*theLen));
        canvas.drawLine(pointOne.x,pointOne.y,pointTwo.x,pointTwo.y,SolidLineRed);

        mid = new Point((allPoint[50].x + allPoint[54].x)/2,(allPoint[50].y + allPoint[54].y)/2);
        drawTria(canvas,allPoint[125].x,allPoint[125].y,allPoint[125].x,mid.y, FaceWidth/20,FaceWidth/25,SolidLineRed,SolidLineRed);
        drawTria(canvas,allPoint[71].x,allPoint[71].y,allPoint[71].x,mid.y, FaceWidth/20,FaceWidth/25,SolidLineRed,SolidLineRed);
        drawTria(canvas,allPoint[123].x,allPoint[123].y,allPoint[123].x,allPoint[71].y,FaceWidth/20,FaceWidth/25,SolidLineRed,SolidLineRed);
        drawTria(canvas,allPoint[24].x,allPoint[24].y,allPoint[1].x,allPoint[24].y,FaceWidth/20,FaceWidth/25,SolidLineGreen,SolidLineGreen);
        drawTria(canvas,allPoint[79].x,allPoint[79].y,allPoint[41].x,allPoint[79].y,FaceWidth/20,FaceWidth/25,SolidLineGreen,SolidLineGreen);

        return bmp;
    }

    public class MyAdapter extends PagerAdapter{
        @Override
        public int getCount() {
            return ivList.size();
        }

        @Override
        public boolean isViewFromObject(@NonNull View view, @NonNull Object o) {
            return view == o;
        }

        @NonNull
        @Override
        public Object instantiateItem(@NonNull ViewGroup container, int position) {
            ImageView imageView = ivList.get(position);
            container.addView(imageView);
            return imageView;
        }

        @Override
        public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
            container.removeView(ivList.get(position));
        }
    }


    private Paint newPaintLine(String color, float width, Paint.Style style){
        Paint ret = new Paint();
        ret.setAntiAlias(true);
        ret.setColor(Color.parseColor(color));
        ret.setStrokeWidth(width);
        ret.setStyle(style);
        return ret;
    }
    private Paint newPaintLine(int r,int g,int b, float width, Paint.Style style){
        Paint ret = new Paint();
        ret.setAntiAlias(true);
        ret.setColor(Color.argb(255,r,g,b));
        ret.setStrokeWidth(width);
        ret.setStyle(style);
        return ret;
    }
    private Paint newDotPaint(String color,float width,float solid,float space,Paint.Style style){
        Paint ret = new Paint();
        ret.setAntiAlias(true);
        ret.setColor(Color.parseColor(color));
        ret.setStrokeWidth(width);
        ret.setStyle(style);
        ret.setPathEffect(new DashPathEffect(new float[]{solid,space},0));  // 每畫5單位，就空白5單位，0間隔
        return ret;
    }
    private Paint newArrowPaint(String color,float width){
        Paint ret = new Paint();
        ret.setAntiAlias(true);
        ret.setColor(Color.parseColor(color));
        ret.setStrokeWidth(width);
        return ret;
    }
    private Paint newWordPaint(String color,float size){
        Paint word = new Paint();
        word.setTextSize(size);
        word.setColor(Color.parseColor(color));
        word.setStyle(Paint.Style.FILL);
        word.setTypeface(Typeface.DEFAULT_BOLD);
        word.setTextAlign(Paint.Align.CENTER);
        return word;
    }

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

    private Bitmap drawBasiconlypoint(Bitmap src) {
        Bitmap dst = src.copy(Bitmap.Config.ARGB_8888,true);
        Paint DotYellow = newPaintLine("#dfe734",4f, Paint.Style.FILL);
        float DotSize = (float)FaceWidth/50;
        float DotSizeSmall = DotSize / 3;

        Canvas canvas = new Canvas(dst);

        // 122個座標點
        for (int i = 0; i < 148; ++i) {
            canvas.drawCircle(allPoint[i].x,allPoint[i].y,DotSizeSmall,DotYellow);
        }


        return dst;
    }

    private Bitmap drawFakeonlypoint(Bitmap src) {
        Bitmap dst = src.copy(Bitmap.Config.ARGB_8888,true);
        Paint DotYellow = newPaintLine("#dfe734",4f, Paint.Style.FILL);
        Paint DotRed = newPaintLine("#ff0000",4f, Paint.Style.FILL);
        float DotSize = (float)FaceWidth/50;
        float DotSizeSmall = DotSize / 3;

        Canvas canvas = new Canvas(dst);

        // 122個座標點
        for (int i = 0; i < 148; ++i) {
            canvas.drawCircle(allPoint[i].x,allPoint[i].y,DotSizeSmall,DotRed);
        }


        return dst;
    }

    private Bitmap drawSymL2R(Bitmap src){
        Matrix matrix = new Matrix();
        matrix.postScale(-1,1);
        int symLine = allPoint[71].x;
        int width = 2*symLine;

        Bitmap result = Bitmap.createBitmap(width,src.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(result);

        Rect srcRect = new Rect(0,0,symLine,src.getHeight());
        Rect dstRect = new Rect(0,0, symLine,src.getHeight());
        canvas.drawBitmap(src,srcRect,dstRect,null);

        Bitmap tmp = Bitmap.createBitmap(src,0,0,src.getWidth(),src.getHeight(),matrix,true);
        srcRect = new Rect(src.getWidth()-symLine,0,src.getWidth(),src.getHeight());
        dstRect = new Rect(symLine,0, width,src.getHeight());
        canvas.drawBitmap(tmp,srcRect,dstRect,null);

        return result;
    }

    private Bitmap drawPointAndLine(Bitmap src,Bitmap reference){

        Bitmap dst = src.copy(Bitmap.Config.ARGB_8888,true);

        Canvas canvas = new Canvas(dst);
        canvas.drawARGB(0,0,0,0);
        Bitmap gray = gray(reference,255);

        Paint blackPaint = newPaintLine("#000000",1, Paint.Style.FILL);
        Paint whitePaint = newPaintLine("#ffffff",1, Paint.Style.FILL);
        Paint profilePaint = newPaintLine("#000000",(float)FaceWidth/50, Paint.Style.STROKE);
        Paint teethPaint = newPaintLine("#fefbe3",1, Paint.Style.FILL);
        Paint teethGapPaint = newPaintLine("#c8c7bd",(float)FaceWidth/200, Paint.Style.FILL);
        teethGapPaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));


        Paint eyeBrowPaint = newPaintLine("#533130",1, Paint.Style.FILL);
        Paint eyeLidPaint = newPaintLine("#3e3b40",(float)FaceWidth/100, Paint.Style.STROKE);
        Paint lipLinePaint = newPaintLine("#810404",(float)FaceWidth/100, Paint.Style.STROKE);


        ArrayList<Point> points = new ArrayList<>();
        Path path = new Path();
        Point mid,mid2,mid3,mid4,ear_shadow1,ear_shadow2,ear_shadow3,ear_shadow4,ear_shadow5;

        Region faceRegion = new Region();
        Path facePath = new Path();

        Region leftEyeRegion = new Region();
        Path leftEyePath = new Path();

        Region rightEyeRegion = new Region();
        Path rightEyePath = new Path();

        Region noseRegion = new Region();
        Path nosePath = new Path();

        Region mouthRegion = new Region();
        Path mouthPath = new Path();

        Region leftEyebrowRegion = new Region();
        Path leftEyebrowPath = new Path();

        Region rightEyebrowRegion = new Region();
        Path rightEyebrowPath = new Path();


        int sumR = 0;
        int sumG = 0;
        int sumB = 0;
        int cnt = 0;
        for(int y = allPoint[67].y - FaceHeight/10 ; y < allPoint[67].y + 10 ; ++y){
            for(int x = allPoint[67].x - FaceWidth/10 ; x < allPoint[67].x + FaceWidth/10 ; ++x){
                int pixel = reference.getPixel(x,y);
                if(Color.green(pixel) - Color.blue(pixel) > 10) {
                    sumR += Color.red(pixel);
                    sumG += Color.green(pixel);
                    sumB += Color.blue(pixel);
                    ++cnt;
                }
            }
            Log.i("MAPPMSG","============");
        }
        if(cnt!=0) {
            sumR /= cnt;
            sumG /= cnt;
            sumB /= cnt;
        }else{
            int pixel = reference.getPixel(allPoint[67].x,allPoint[67].y);
            sumR = Color.red(pixel);
            sumG = Color.green(pixel);
            sumB = Color.blue(pixel);
        }

        Log.i("MAPPMSG","sumR: " + sumR);
        Log.i("MAPPMSG","sumG: " + sumG);
        Log.i("MAPPMSG","sumB: " + sumB);

        Paint shadowPaint = newPaintLine(sumR,sumG,sumB,1, Paint.Style.FILL); //d1cbcb
        sumR += 20;
        sumG += 20;
        sumB += 20;
        if(sumR > 255) sumR = 255;
        if(sumG > 255) sumG = 255;
        if(sumB > 255) sumB = 255;
        Paint skinPaint = newPaintLine(230,230,230,1, Paint.Style.FILL);
/*
        Bitmap source = reference.copy(Bitmap.Config.ARGB_8888,true);
        Bitmap bmOverlay = Bitmap.createBitmap(320, 480, Bitmap.Config.ARGB_8888);

        Paint paint = new Paint();
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));

        Canvas ca = new Canvas(bmOverlay);
        ca.drawBitmap(source, 0, 0, null);
        ca.drawRect(allPoint[10].x, allPoint[10].y, allPoint[28].x, allPoint[28].y, paint);

        Paint skinPaint = new Paint();
        skinPaint.setColor(getDominantColor(bmOverlay));
*/

        sumR += 20;
        sumG += 20;
        sumB += 20;
        if(sumR > 255) sumR = 255;
        if(sumG > 255) sumG = 255;
        if(sumB > 255) sumB = 255;
        Paint nosePaint = newPaintLine(sumR,sumG,sumB,(float)FaceWidth/100, Paint.Style.STROKE);


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     臉型      ========================================= //
        // ========================================================================================= //
        // ========================================================================================= //
        int x0,y0;
        y0 = allPoint[134].y;
        x0 = (int)((float)(y0 - allPoint[1].y)/((float)(allPoint[0].y - allPoint[1].y)/(float)(allPoint[0].x - allPoint[1].x)))+allPoint[1].x;
        //mid = new Point(allPoint[0].x,allPoint[134].y);
        mid = new Point(x0,y0);

        y0 = allPoint[141].y;
        x0 = (int)((float)(y0 - allPoint[24].y)/((float)(allPoint[2].y - allPoint[24].y)/(float)(allPoint[2].x - allPoint[24].x)))+allPoint[24].x;
        //mid2 = new Point(allPoint[2].x,allPoint[141].y);
        mid2 = new Point(x0,y0);

        if(allPoint[116].y >allPoint[57].y)
        {
            y0 = allPoint[116].y;
            x0 = (int) ((float) (y0 - allPoint[57].y) / ((float) (allPoint[68].y - allPoint[57].y) / (float) (allPoint[68].x - allPoint[57].x))) + allPoint[57].x;
            //mid3 = new Point(allPoint[32].x,allPoint[116].y);
            mid3 = new Point(x0, y0);
        }
        else {
            y0 = allPoint[116].y;
            x0 = (int) ((float) (y0 - allPoint[46].y) / ((float) (allPoint[57].y - allPoint[46].y) / (float) (allPoint[57].x - allPoint[46].x))) + allPoint[46].x;
            //mid3 = new Point(allPoint[32].x,allPoint[116].y);
            mid3 = new Point(x0, y0);
        }

        if(allPoint[121].y > allPoint[39].y)
        {
            y0 = allPoint[121].y;
            x0 = (int) ((float) (y0 - allPoint[39].y) / ((float) (allPoint[40].y - allPoint[39].y) / (float) (allPoint[40].x - allPoint[39].x))) + allPoint[39].x;
            //mid4 = new Point(allPoint[39].x,allPoint[121].y);
            mid4 = new Point(x0, y0);
        }
        else {
            y0 = allPoint[121].y;
            x0 = (int) ((float) (y0 - allPoint[13].y) / ((float) (allPoint[39].y - allPoint[13].y) / (float) (allPoint[39].x - allPoint[13].x))) + allPoint[13].x;
            //mid4 = new Point(allPoint[39].x,allPoint[121].y);
            mid4 = new Point(x0, y0);
        }

        if(allPoint[116].y >allPoint[57].y) {
            points.add(allPoint[0]);
            points.add(mid);
            points.add(allPoint[134]);
            points.add(allPoint[111]);
            points.add(allPoint[28]);
            points.add(allPoint[113]);
            points.add(allPoint[29]);
            points.add(allPoint[114]);
            points.add(allPoint[30]);
            points.add(allPoint[115]);
            points.add(allPoint[31]);
            points.add(allPoint[116]);
            points.add(mid3);
            points.add(allPoint[68]);
            points.add(allPoint[79]);
            points.add(allPoint[90]);
            points.add(allPoint[101]);
            points.add(allPoint[112]);
            points.add(allPoint[123]);
            points.add(allPoint[44]);
            points.add(allPoint[43]);
            points.add(allPoint[42]);
            points.add(allPoint[41]);
            points.add(allPoint[40]);
            points.add(mid4);
            points.add(allPoint[121]);
            points.add(allPoint[38]);
            points.add(allPoint[120]);
            points.add(allPoint[37]);
            points.add(allPoint[119]);
            points.add(allPoint[36]);
            points.add(allPoint[118]);
            points.add(allPoint[34]);
            points.add(allPoint[117]);
            points.add(allPoint[141]);
            points.add(mid2);
            points.add(allPoint[2]);
            points.add(allPoint[15]);
            points.add(allPoint[127]);
            points.add(allPoint[14]);
            points.add(allPoint[126]);
            points.add(allPoint[12]);
            points.add(allPoint[125]);
            points.add(allPoint[11]);
            points.add(allPoint[124]);
            points.add(allPoint[10]);
            points.add(allPoint[122]);
            points.add(allPoint[9]);// points.add(allPoint[0]); points.add(allPoint[1]);
        }
        else
        {
            points.add(allPoint[0]);
            points.add(mid);
            points.add(allPoint[134]);
            points.add(allPoint[111]);
            points.add(allPoint[28]);
            points.add(allPoint[113]);
            points.add(allPoint[29]);
            points.add(allPoint[114]);
            points.add(allPoint[30]);
            points.add(allPoint[115]);
            points.add(allPoint[31]);
            points.add(allPoint[116]);
            points.add(mid3);
            points.add(allPoint[57]);
            points.add(allPoint[68]);
            points.add(allPoint[79]);
            points.add(allPoint[90]);
            points.add(allPoint[101]);
            points.add(allPoint[112]);
            points.add(allPoint[123]);
            points.add(allPoint[44]);
            points.add(allPoint[43]);
            points.add(allPoint[42]);
            points.add(allPoint[41]);
            points.add(allPoint[40]);
            points.add(allPoint[39]);
            points.add(mid4);
            points.add(allPoint[121]);
            points.add(allPoint[38]);
            points.add(allPoint[120]);
            points.add(allPoint[37]);
            points.add(allPoint[119]);
            points.add(allPoint[36]);
            points.add(allPoint[118]);
            points.add(allPoint[34]);
            points.add(allPoint[117]);
            points.add(allPoint[141]);
            points.add(mid2);
            points.add(allPoint[2]);
            points.add(allPoint[15]);
            points.add(allPoint[127]);
            points.add(allPoint[14]);
            points.add(allPoint[126]);
            points.add(allPoint[12]);
            points.add(allPoint[125]);
            points.add(allPoint[11]);
            points.add(allPoint[124]);
            points.add(allPoint[10]);
            points.add(allPoint[122]);
            points.add(allPoint[9]);// points.add(allPoint[0]); points.add(allPoint[1]);
        }

        facePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
//            Point p1 = points.get(i);
//            facePath.moveTo(points.get(i).x,points.get(i).y);
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            facePath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
            //facePath.quadTo(p2.x,p2.y,p3.x,p3.y);
            //facePath.lineTo(p2.x,p2.y);

//            int w = Math.abs(p2.x - p1.x);
//            int h = Math.abs(p2.y - p1.y);
//            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);
//
//
//            if(p2.x >= p1.x)
//                facePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
//            else
//                facePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        faceRegion.setPath(facePath,new Region(0,0,reference.getWidth(),reference.getHeight()));
        drawRegion(canvas,faceRegion,skinPaint);
        points.clear();

        // ========================================================================================= //
        // ========================================================================================= //
        // =============================     耳朵/眉毛     ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //

        // 左耳
        ear_shadow1 = new Point(allPoint[111].x,allPoint[111].y+(allPoint[116].y - allPoint[111].y)/8);
        ear_shadow2 = new Point(allPoint[113].x + (allPoint[0].x - allPoint[113].x)/5,allPoint[113].y);
        ear_shadow3 = new Point(allPoint[114].x + (allPoint[0].x - allPoint[114].x)/5,allPoint[114].y);
        ear_shadow4 = new Point(allPoint[115].x + (allPoint[0].x - allPoint[115].x)/5,allPoint[115].y);
        ear_shadow5 = new Point(allPoint[116].x,allPoint[116].y-(allPoint[116].y - allPoint[111].y)/8);

        points.add(ear_shadow1);points.add(ear_shadow2);points.add(ear_shadow3);points.add(ear_shadow4);points.add(ear_shadow5);
        points.add(allPoint[46]);points.add(allPoint[1]);points.add(allPoint[0]);points.add(ear_shadow1);
        //drawCurve(canvas,points,skinPaint,false);
        points.clear();
        // 右耳
        mid = new Point((allPoint[2].x + allPoint[24].x)/2,(allPoint[2].y + allPoint[24].y)/2);
        //points.add(mid); points.add(allPoint[117]); points.add(allPoint[118]); points.add(allPoint[119]);
        //points.add(allPoint[120]); points.add(allPoint[121]); points.add(allPoint[39]);
        points.add(mid);points.add(allPoint[117]);points.add(allPoint[34]);points.add(allPoint[118]);points.add(allPoint[36]);points.add(allPoint[119]);
        points.add(allPoint[37]);points.add(allPoint[120]);points.add(allPoint[38]);points.add(allPoint[121]);points.add(allPoint[39]);
        //drawCurve(canvas,points,skinPaint,false);
        points.clear();
        // 左眉毛
        points.add(allPoint[45]); points.add(allPoint[47]); points.add(allPoint[48]); points.add(allPoint[49]);
        points.add(allPoint[50]); points.add(allPoint[51]); points.add(allPoint[52]); points.add(allPoint[53]);points.add(allPoint[45]); points.add(allPoint[47]);

        leftEyebrowPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            leftEyebrowPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }
/*
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                leftEyebrowPath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                leftEyebrowPath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        */
        leftEyebrowRegion.setPath(leftEyebrowPath,new Region(allPoint[45].x,allPoint[48].y,allPoint[50].x,(allPoint[52].y + allPoint[130].y)/2));
        //drawRegion(canvas,leftEyebrowRegion,eyeBrowPaint);
//        drawCurve(canvas,points,eyeBrowPaint,true);
        points.clear();
        // 右眉毛
        points.add(allPoint[54]); points.add(allPoint[55]); points.add(allPoint[56]); points.add(allPoint[58]);
        points.add(allPoint[59]); points.add(allPoint[60]); points.add(allPoint[61]); points.add(allPoint[54]); points.add(allPoint[55]);

        rightEyebrowPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            rightEyebrowPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }
        /*
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                rightEyebrowPath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                rightEyebrowPath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        */
        rightEyebrowRegion.setPath(rightEyebrowPath,new Region(allPoint[54].x,allPoint[56].y,allPoint[59].x,(allPoint[61].y + allPoint[85].y)/2));
        //drawRegion(canvas,rightEyebrowRegion,eyeBrowPaint);
//        drawCurve(canvas,points,eyeBrowPaint,true);
        points.clear();


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     鼻子      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //
        points.add(allPoint[69]); points.add(allPoint[70]); points.add(allPoint[18]); points.add(allPoint[71]);
        points.add(allPoint[19]); points.add(allPoint[73]); points.add(allPoint[72]); points.add(allPoint[66]);
        points.add(allPoint[17]); points.add(allPoint[64]); points.add(allPoint[63]); points.add(allPoint[16]);
        points.add(allPoint[65]); points.add(allPoint[69]);

        nosePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i=1 ; i < points.size() ; ++i){
            nosePath.lineTo(points.get(i).x,points.get(i).y);
        }
        noseRegion.setPath(nosePath,new Region(NoseLeftPoint.x,allPoint[64].y,NoseRightPoint.x,NoseLowPoint.y));
//        drawCurve(canvas,points,nosePaint,false);
        points.clear();
        // 鼻孔
//        float tmpH = allPoint[59].y - allPoint[55].y;
//        canvas.drawOval(allPoint[58].x,allPoint[58].y - tmpH/10,allPoint[18].x,allPoint[58].y,profilePaint);
//        canvas.drawOval(allPoint[19].x,allPoint[19].y - tmpH/10,allPoint[61].x,allPoint[19].y,profilePaint);


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     眼睛      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //
        // 眼球畫筆
        Paint eyePaint = newPaintLine("#000000",(float)FaceWidth/200, Paint.Style.FILL);
        eyePaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));

        Bitmap eye = Bitmap.createBitmap(dst.getWidth(),dst.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas tmpCanvas = new Canvas(eye);
        // 左眼Region
        points.add(allPoint[74]); points.add(allPoint[82]); points.add(allPoint[81]); points.add(allPoint[80]);
        points.add(allPoint[78]); points.add(allPoint[77]); points.add(allPoint[76]); points.add(allPoint[75]);
        points.add(allPoint[74]);

        leftEyePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                leftEyePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                leftEyePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        leftEyeRegion.setPath(leftEyePath,new Region(EyeLeftLeftPoint.x,EyeLeftTopPoint.y,EyeLeftRightPoint.x,EyeLeftDownPoint.y));
//        drawCurve(tmpCanvas,points,teethPaint,false);
        points.clear();
        // 右眼Region
        points.add(allPoint[83]); points.add(allPoint[91]); points.add(allPoint[89]); points.add(allPoint[88]);
        points.add(allPoint[87]); points.add(allPoint[86]); points.add(allPoint[85]); points.add(allPoint[84]);
        points.add(allPoint[83]);
        rightEyePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                rightEyePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                rightEyePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        rightEyeRegion.setPath(rightEyePath,new Region(EyeRightLeftPoint.x,EyeRightTopPoint.y,EyeRightRightPoint.x,EyeRightDownPoint.y));
//        drawCurve(tmpCanvas,points,teethPaint,false);
        points.clear();

        float radius = (float)(allPoint[23].x-allPoint[22].x)/2 > (float)(allPoint[26].x-allPoint[25].x)/2? (float)(allPoint[23].x-allPoint[22].x)/2 :(float)(allPoint[26].x-allPoint[25].x)/2;
        radius *= 1.05;
        // 左眼球
        path.addCircle((allPoint[22].x+allPoint[23].x)/2,(allPoint[22].y+allPoint[23].y)/2,radius,Path.Direction.CW);
//        tmpCanvas.drawPath(path,eyePaint);
        path.reset();
        // 右眼球
        path.addCircle((allPoint[25].x+allPoint[26].x)/2,(allPoint[25].y+allPoint[26].y)/2,radius,Path.Direction.CW);
//        tmpCanvas.drawPath(path,eyePaint);
        path.reset();
        Paint p = new Paint();
//        canvas.drawBitmap(eye,0,0,p);
        /*
        // 左雙眼皮線
        points.add(allPoint[121]); points.add(allPoint[120]); points.add(allPoint[119]); points.add(allPoint[118]);
        points.add(allPoint[117]); points.add(allPoint[116]);
        drawCurve(canvas,points,eyeLidPaint,false);
        points.clear();
        // 右雙眼皮線
        points.add(allPoint[3]); points.add(allPoint[4]); points.add(allPoint[5]); points.add(allPoint[6]);
        points.add(allPoint[7]); points.add(allPoint[8]);
        drawCurve(canvas,points,eyeLidPaint,false);
        points.clear();
        */


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     嘴唇      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //

        // 嘴唇(外)  80 83 86 90 左上右下
        int tmpH = (allPoint[102].y - allPoint[109].y)/4;
        mid = new Point((allPoint[109].x + allPoint[102].x)/2,(allPoint[109].y + allPoint[102].y)/2);
        for(int y = (int)(mid.y - tmpH) ; y < mid.y + tmpH ; ++y){
            for(int x = (int)(mid.x - tmpH) ; x < mid.x + tmpH ; ++x){
                int pixel = reference.getPixel(x,y);
                sumR += Color.red(pixel);
                sumG += Color.green(pixel);
                sumB += Color.blue(pixel);
                ++cnt;
            }
        }
        sumR = sumR/cnt + 30;
        sumG = sumG/cnt + 30;
        sumB = sumB/cnt + 30;
        if (sumR > 255)
            sumR = 255;
        if (sumG > 255)
            sumG = 255;
        if (sumB > 255)
            sumB = 255;

        Paint lowerlipPaint = newPaintLine(sumR,sumG,sumB,1, Paint.Style.FILL);

        sumR = 0;
        sumG = 0;
        sumB = 0;
        cnt = 0;

        tmpH = (allPoint[106].y - allPoint[95].y)/4;
        mid = new Point((allPoint[95].x + allPoint[106].x)/2,(allPoint[95].y + allPoint[106].y)/2);
        for(int y = (int)(mid.y - tmpH) ; y < mid.y + tmpH ; ++y){
            for(int x = (int)(mid.x - tmpH) ; x < mid.x + tmpH ; ++x){
                int pixel = reference.getPixel(x,y);
                sumR += Color.red(pixel);
                sumG += Color.green(pixel);
                sumB += Color.blue(pixel);
                ++cnt;
            }
        }
        sumR = sumR/cnt + 30;
        sumG = sumG/cnt + 30;
        sumB = sumB/cnt + 30;
        if (sumR > 255)
            sumR = 255;
        if (sumG > 255)
            sumG = 255;
        if (sumB > 255)
            sumB = 255;
        Paint upperlipPaint = newPaintLine(sumR,sumG,sumB,1, Paint.Style.FILL);

        points.add(allPoint[92]);points.add(allPoint[94]);points.add(allPoint[93]);points.add(allPoint[95]);
        points.add(allPoint[96]);points.add(allPoint[97]);points.add(allPoint[98]);points.add(allPoint[99]);
        points.add(allPoint[100]);points.add(allPoint[102]);points.add(allPoint[103]);points.add(allPoint[104]);
        points.add(allPoint[92]);
        //points.add(allPoint[80]);points.add(allPoint[82]);
        /*
        mouthPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            mouthPath.quadTo(p2.x,p2.y,p3.x,p3.y);
            mouthPath.lineTo(p2.x,p2.y);
        }*/
        /*
        //only upper
        points.add(allPoint[80]); points.add(allPoint[92]); points.add(allPoint[91]); points.add(allPoint[90]);
        points.add(allPoint[88]); points.add(allPoint[87]); points.add(allPoint[86]); points.add(allPoint[96]);
        points.add(allPoint[97]);points.add(allPoint[98]);points.add(allPoint[80]);


        points.add(allPoint[85]);
        points.add(allPoint[84]); points.add(allPoint[83]); points.add(allPoint[81]); points.add(allPoint[82]);
        points.add(allPoint[80]);
        */

        mouthPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            if (i == 0 || i == 5 || i == 6 || i == 7 || i == 11 || i == 12){
                Point p1 = points.get(i);
                Point p2 = points.get(i + 1);
                int w = Math.abs(p2.x - p1.x);
                int h = Math.abs(p2.y - p1.y);
                mid = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);

                if (p2.x >= p1.x)
                    mouthPath.quadTo(mid.x, mid.y + h / 4, p2.x, p2.y);
                else
                    mouthPath.quadTo(mid.x, mid.y - h / 4, p2.x, p2.y);
            }
            else {
                Point p1 = points.get(i);
                Point p2 = points.get(i+1);
                Point p3 = points.get(i+2);
                mouthPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
            }
        }

        mouthRegion.setPath(mouthPath,new Region(MouthLeftPoint.x,MouthPeak.y,MouthRightPoint.x,allPoint[102].y));
        //drawCurve(canvas,points,lowerlipPaint,false);
        points.clear();

        points.add(allPoint[92]);points.add(allPoint[105]);points.add(allPoint[106]);points.add(allPoint[107]);
        points.add(allPoint[98]);points.add(allPoint[97]);points.add(allPoint[96]);points.add(allPoint[95]);
        points.add(allPoint[93]);points.add(allPoint[94]);points.add(allPoint[92]);
        //drawCurve(canvas,points,upperlipPaint,false);
        points.clear();




        float lipHeight = (float)(allPoint[102].y - allPoint[95].y);
        if( (allPoint[109].y - allPoint[106].y) > 0.15 * lipHeight) {  // 如果嘴巴打開程度 > 5%嘴唇高度 就畫出來
            // 嘴唇(內)
            // 處理牙齒部分 // 80 86分五等分
            Bitmap lip = Bitmap.createBitmap(dst.getWidth(),dst.getHeight(), Bitmap.Config.ARGB_8888);
            tmpCanvas = new Canvas(lip);
            // 畫出牙齒(白色)
            points.add(allPoint[92]); points.add(allPoint[105]); points.add(allPoint[106]); points.add(allPoint[107]);
            points.add(allPoint[98]); points.add(allPoint[108]); points.add(allPoint[109]); points.add(allPoint[110]);
            drawCurve(tmpCanvas, points, teethPaint, true);
            // 畫出牙齒間隔(黑色)
            float space = ((float)allPoint[98].x - (float)allPoint[92].x)/6;
            for(int i=1 ; i <= 5 ; ++i)
                tmpCanvas.drawLine(allPoint[92].x + i*space,allPoint[95].y,allPoint[92].x + i*space,allPoint[102].y,eyePaint);
            //canvas.drawBitmap(lip,0,0,p);

            points.clear();
        }
//        else {
//            // 嘴唇線
//            points.add(allPoint[80]); points.add(allPoint[97]); points.add(allPoint[86]);
//            drawCurve(canvas, points, lipLinePaint, false);
//            points.clear();
//        }

        // 臉 排除 雙眼、鼻子、嘴唇剩下的地方
        Region finalRegion = new Region(faceRegion);  // copy faceRegion
        finalRegion.op(leftEyeRegion, Region.Op.XOR);
        finalRegion.op(rightEyeRegion, Region.Op.XOR);
//        finalRegion.op(noseRegion, Region.Op.XOR);
        finalRegion.op(mouthRegion, Region.Op.XOR);



//        drawRegion(canvas,finalRegion,whitePaint);
        Resources res = getResources();
        Bitmap stroke = BitmapFactory.decodeResource(res, R.drawable.stroke1);
        Bitmap resizedBitmap = Bitmap.createScaledBitmap(stroke, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke2 = BitmapFactory.decodeResource(res, R.drawable.stroke2);
        Bitmap resizedBitmap2 = Bitmap.createScaledBitmap(stroke2, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke3 = BitmapFactory.decodeResource(res, R.drawable.stroke3);
        Bitmap resizedBitmap3 = Bitmap.createScaledBitmap(stroke3, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke4 = BitmapFactory.decodeResource(res, R.drawable.stroke4);
        Bitmap resizedBitmap4 = Bitmap.createScaledBitmap(stroke4, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke5 = BitmapFactory.decodeResource(res, R.drawable.stroke5);
        Bitmap resizedBitmap5 = Bitmap.createScaledBitmap(stroke5, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke6 = BitmapFactory.decodeResource(res, R.drawable.stroke6);
        Bitmap resizedBitmap6 = Bitmap.createScaledBitmap(stroke6, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke7 = BitmapFactory.decodeResource(res, R.drawable.stroke7);
        Bitmap resizedBitmap7 = Bitmap.createScaledBitmap(stroke7, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke8 = BitmapFactory.decodeResource(res, R.drawable.stroke8);
        Bitmap resizedBitmap8 = Bitmap.createScaledBitmap(stroke8, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke9 = BitmapFactory.decodeResource(res, R.drawable.stroke9);
        Bitmap resizedBitmap9 = Bitmap.createScaledBitmap(stroke9, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke10 = BitmapFactory.decodeResource(res, R.drawable.stroke10);
        Bitmap resizedBitmap10 = Bitmap.createScaledBitmap(stroke10, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke11 = BitmapFactory.decodeResource(res, R.drawable.stroke11);
        Bitmap resizedBitmap11 = Bitmap.createScaledBitmap(stroke11, gray.getWidth(), gray.getHeight(), false);
        Bitmap stroke12 = BitmapFactory.decodeResource(res, R.drawable.stroke12);
        Bitmap resizedBitmap12 = Bitmap.createScaledBitmap(stroke12, gray.getWidth(), gray.getHeight(), false);
        int gray_temp, red_temp, green_temp, blue_temp,stroke_temp,stroke2_temp,stroke3_temp,stroke4_temp,stroke5_temp,stroke6_temp,stroke7_temp,stroke8_temp,stroke9_temp,stroke10_temp;
        int stroke11_temp,stroke12_temp;
        int new_color;
        float[] hsv = new float[3];
        for(int i=0 ; i<gray.getWidth() ; i++) {
            for (int j = 0; j < gray.getHeight(); j++) {
                if(finalRegion.contains(i,j)||mouthRegion.contains(i,j) || rightEyeRegion.contains(i,j) || leftEyeRegion.contains(i,j)||leftEyebrowRegion.contains(i,j) || rightEyebrowRegion.contains(i,j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));
                    stroke_temp = Color.red(resizedBitmap.getPixel(i, j));
                    stroke2_temp = Color.red(resizedBitmap2.getPixel(i, j));
                    stroke3_temp = Color.red(resizedBitmap3.getPixel(i, j));
                    stroke4_temp = Color.red(resizedBitmap4.getPixel(i, j));
                    stroke5_temp = Color.red(resizedBitmap5.getPixel(i, j));
                    stroke6_temp = Color.red(resizedBitmap6.getPixel(i, j));
                    stroke7_temp = Color.red(resizedBitmap7.getPixel(i, j));
                    stroke8_temp = Color.red(resizedBitmap8.getPixel(i, j));
                    stroke9_temp = Color.red(resizedBitmap9.getPixel(i, j));
                    stroke10_temp = Color.red(resizedBitmap10.getPixel(i, j));
                    stroke11_temp = Color.red(resizedBitmap11.getPixel(i, j));
                    stroke12_temp = Color.red(resizedBitmap12.getPixel(i, j));

                    red_temp = Color.red(dst.getPixel(i, j));
                    green_temp = Color.green(dst.getPixel(i, j));
                    blue_temp = Color.blue(dst.getPixel(i, j));
                    Color.RGBToHSV(red_temp, green_temp, blue_temp, hsv);


                    if(gray_temp < 10 && stroke_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp < 10 && stroke_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 10 && gray_temp < 20 && stroke2_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 10 && gray_temp < 20 && stroke2_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 20 && gray_temp < 30 && stroke3_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 20 && gray_temp < 30 && stroke3_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 30 && gray_temp < 40 && stroke4_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 30 && gray_temp < 40 && stroke4_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 40 && gray_temp < 50 && stroke5_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 40 && gray_temp < 50 && stroke5_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 50 && gray_temp < 60 && stroke6_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 50 && gray_temp < 60 && stroke6_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 60 && gray_temp < 70 && stroke7_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 60 && gray_temp < 70 && stroke7_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 70 && gray_temp < 80 && stroke8_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 70 && gray_temp < 80 && stroke8_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 80 && gray_temp < 90 && stroke9_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 80 && gray_temp < 90 && stroke9_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 90 && gray_temp < 100 && stroke10_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 90 && gray_temp < 100 && stroke10_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 100 && gray_temp < 110 && stroke11_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 100 && gray_temp < 110 && stroke11_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 110 && gray_temp < 120 && stroke12_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 110 && gray_temp < 120 && stroke12_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 120 && gray_temp < 130 && stroke_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 120 && gray_temp < 130 && stroke_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 130 && gray_temp < 140  && stroke2_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.35;
                    else if (gray_temp >= 130 && gray_temp < 140  && stroke2_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 140 && gray_temp < 150  && stroke3_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.35;
                    else if (gray_temp >= 140 && gray_temp < 150  && stroke3_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 150 && gray_temp < 160  && stroke4_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 150 && gray_temp < 160  && stroke4_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 160 && gray_temp < 170  && stroke5_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 160 && gray_temp < 170  && stroke5_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 170 && gray_temp < 180  && stroke6_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 170 && gray_temp < 180  && stroke6_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 180 && gray_temp < 190  && stroke7_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 180 && gray_temp < 190  && stroke7_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 190 && gray_temp < 200  && stroke8_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 190 && gray_temp < 200  && stroke8_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 200 && gray_temp < 210  && stroke9_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 200 && gray_temp < 210  && stroke9_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 210 && gray_temp < 220  && stroke10_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 210 && gray_temp < 220  && stroke10_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 220 && gray_temp < 230  && stroke11_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 220 && gray_temp < 230  && stroke11_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 230 && gray_temp < 240  && stroke12_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 230 && gray_temp < 240  && stroke12_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 240  && stroke_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;
                    else if (gray_temp >= 240  && stroke_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;

                    /*if(gray_temp < 10 && stroke_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp < 10 && stroke_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 10 && gray_temp < 20 && stroke2_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 10 && gray_temp < 20 && stroke2_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 20 && gray_temp < 30 && stroke3_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 20 && gray_temp < 30 && stroke3_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 30 && gray_temp < 40 && stroke4_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 30 && gray_temp < 40 && stroke4_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 40 && gray_temp < 50 && stroke5_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 40 && gray_temp < 50 && stroke5_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 50 && gray_temp < 60 && stroke6_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 50 && gray_temp < 60 && stroke6_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if(gray_temp >= 60 && gray_temp < 70 && stroke7_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.27;
                    else if(gray_temp >= 60 && gray_temp < 70 && stroke7_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.12;
                    else if (gray_temp >= 70 && gray_temp < 80 && stroke8_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 70 && gray_temp < 80 && stroke8_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.175;
                    else if (gray_temp >= 80 && gray_temp < 90 && stroke9_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 80 && gray_temp < 90 && stroke9_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.175;
                    else if (gray_temp >= 90 && gray_temp < 100 && stroke10_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 90 && gray_temp < 100 && stroke10_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.175;
                    else if (gray_temp >= 100 && gray_temp < 110 && stroke11_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 100 && gray_temp < 110 && stroke11_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.175;
                    else if (gray_temp >= 110 && gray_temp < 120 && stroke12_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 110 && gray_temp < 120 && stroke12_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.175;
                    else if (gray_temp >= 120 && gray_temp < 130 && stroke_temp > 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 120 && gray_temp < 130 && stroke_temp <= 128)
                        hsv[2] *= (float)gray_temp/255 + (float)0.175;
                    else if (gray_temp >= 130 && gray_temp < 150)
                        hsv[2] *= (float)gray_temp/255 + (float)0.35;
                    else if (gray_temp >= 150)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;*/



                    if(hsv[2] > 1)
                        hsv[2] = 1;

                    if(hsv[2] < 0)
                        hsv[2] = 0;


                    new_color = Color.HSVToColor(hsv);
                    dst.setPixel(i,j,new_color);
                }
/*
                if(mouthRegion.contains(i,j) || rightEyeRegion.contains(i,j) || leftEyeRegion.contains(i,j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));
                    red_temp = Color.red(reference.getPixel(i, j));
                    green_temp = Color.green(reference.getPixel(i, j));
                    blue_temp = Color.blue(reference.getPixel(i, j));
                    Color.RGBToHSV(red_temp, green_temp, blue_temp, hsv);
                    new_color = Color.HSVToColor(hsv);
                    dst.setPixel(i,j,new_color);
                }
                hsv[2] = 0;

                if(leftEyebrowRegion.contains(i,j) || rightEyebrowRegion.contains(i,j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));
                    red_temp = Color.red(dst.getPixel(i, j));
                    green_temp = Color.green(dst.getPixel(i, j));
                    blue_temp = Color.blue(dst.getPixel(i, j));
                    Color.RGBToHSV(red_temp, green_temp, blue_temp, hsv);

                    //if(gray_temp > 50) {
                    hsv[2] *= (float) gray_temp / 255 + (float) 0.4;
                    if(hsv[2] > 1)
                        hsv[2] = 1;
                    new_color = Color.HSVToColor(hsv);
                    dst.setPixel(i, j, new_color);
                    //}
                }
                */
            }
        }


        return dst;
    }
    private Bitmap drawCartoon(Bitmap src,Bitmap reference) {
        Bitmap dst = src.copy(Bitmap.Config.ARGB_8888,true);

        Canvas canvas = new Canvas(dst);
        canvas.drawARGB(0,0,0,0);
        Bitmap gray = gray(reference,255);

        Paint blackPaint = newPaintLine("#000000",1, Paint.Style.FILL);
        Paint whitePaint = newPaintLine("#ffffff",1, Paint.Style.FILL);
        Paint profilePaint = newPaintLine("#000000",(float)FaceWidth/50, Paint.Style.STROKE);


        Paint eyeBrowPaint = newPaintLine("#0C0B09",1, Paint.Style.FILL);
        Paint eyeLidPaint = newPaintLine("#0C0B09",(float)FaceWidth/70, Paint.Style.STROKE);//OLD #6F392D

        /*Paint eyeBrowPaint = newPaintLine("#8B7671",1, Paint.Style.FILL);
        Paint eyeLidPaint = newPaintLine("#8B7671",(float)FaceWidth/70, Paint.Style.STROKE);//OLD #6F392D*/

        Paint eyeLidPaint1 = newPaintLine("#8B7671",(float)FaceWidth/200, Paint.Style.STROKE);
        Paint lipLinePaint = newPaintLine("#4D2E11",(float)FaceWidth/100, Paint.Style.STROKE);

        ArrayList<Point> points = new ArrayList<>();
        Path path = new Path();
        Point mid,mid2,mid3,mid4,ear_shadow1,ear_shadow2,ear_shadow3,ear_shadow4,ear_shadow5;

        Region faceRegion = new Region();
        Path facePath = new Path();

        Region leftEyeRegion = new Region();
        Path leftEyePath = new Path();

        Region rightEyeRegion = new Region();
        Path rightEyePath = new Path();

        Region noseRegion = new Region();
        Path nosePath = new Path();

        Region mouthRegion = new Region();
        Path mouthPath = new Path();

        Region leftEyebrowRegion = new Region();
        Path leftEyebrowPath = new Path();


        Region rightEyebrowRegion = new Region();
        Path rightEyebrowPath = new Path();


        //Region leftEarRegion = new Region();
        //Path facePath = new Path();

        int sumR = 0;
        int sumG = 0;
        int sumB = 0;
        int cnt = 0;
        for(int y = allPoint[67].y - 5 ; y < allPoint[67].y + 5 ; ++y){
            for(int x = allPoint[67].x - 5 ; x < allPoint[67].x + 5 ; ++x){
                int pixel = reference.getPixel(x,y);
                if(Color.green(pixel) - Color.blue(pixel) > 10) {
                    sumR += Color.red(pixel);
                    sumG += Color.green(pixel);
                    sumB += Color.blue(pixel);
                    ++cnt;
                }
            }
            Log.i("MAPPMSG","============");
        }
        if(cnt!=0) {
            sumR /= cnt;
            sumG /= cnt;
            sumB /= cnt;
        }else{
            int pixel = reference.getPixel(allPoint[67].x,allPoint[67].y);
            sumR = Color.red(pixel);
            sumG = Color.green(pixel);
            sumB = Color.blue(pixel);
        }

        Log.i("MAPPMSG","sumR: " + sumR);
        Log.i("MAPPMSG","sumG: " + sumG);
        Log.i("MAPPMSG","sumB: " + sumB);

        Paint shadowPaint = newPaintLine(158,80,68,1, Paint.Style.FILL); //d1cbcb
        //Paint shadowPaint = newPaintLine(sumR,sumG,sumB,1, Paint.Style.FILL); //d1cbcb
        sumR += 20;
        sumG += 20;
        sumB += 20;
        if(sumR > 255) sumR = 255;
        if(sumG > 255) sumG = 255;
        if(sumB > 255) sumB = 255;
        Paint skinPaint = newPaintLine(237,197,169,1, Paint.Style.FILL);
        //Paint skinPaint = newPaintLine(sumR,sumG,sumB,1, Paint.Style.FILL);
        sumR += 20;
        sumG += 20;
        sumB += 20;
        if(sumR > 255) sumR = 255;
        if(sumG > 255) sumG = 255;
        if(sumB > 255) sumB = 255;
        Paint nosePaint = newPaintLine(sumR,sumG,sumB,(float)FaceWidth/100, Paint.Style.STROKE);


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     臉型      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //
        int x0,y0;
        y0 = allPoint[134].y;
        x0 = (int)((float)(y0 - allPoint[1].y)/((float)(allPoint[0].y - allPoint[1].y)/(float)(allPoint[0].x - allPoint[1].x)))+allPoint[1].x;
        //mid = new Point(allPoint[0].x,allPoint[134].y);
        mid = new Point(x0,y0);

        y0 = allPoint[141].y;
        x0 = (int)((float)(y0 - allPoint[24].y)/((float)(allPoint[2].y - allPoint[24].y)/(float)(allPoint[2].x - allPoint[24].x)))+allPoint[24].x;
        //mid2 = new Point(allPoint[2].x,allPoint[141].y);
        mid2 = new Point(x0,y0);

        if(allPoint[116].y >allPoint[57].y)
        {
            y0 = allPoint[116].y;
            x0 = (int) ((float) (y0 - allPoint[57].y) / ((float) (allPoint[68].y - allPoint[57].y) / (float) (allPoint[68].x - allPoint[57].x))) + allPoint[57].x;
            //mid3 = new Point(allPoint[32].x,allPoint[116].y);
            mid3 = new Point(x0, y0);
        }
        else {
            y0 = allPoint[116].y;
            x0 = (int) ((float) (y0 - allPoint[46].y) / ((float) (allPoint[57].y - allPoint[46].y) / (float) (allPoint[57].x - allPoint[46].x))) + allPoint[46].x;
            //mid3 = new Point(allPoint[32].x,allPoint[116].y);
            mid3 = new Point(x0, y0);
        }

        if(allPoint[121].y > allPoint[39].y)
        {
            y0 = allPoint[121].y;
            x0 = (int) ((float) (y0 - allPoint[39].y) / ((float) (allPoint[40].y - allPoint[39].y) / (float) (allPoint[40].x - allPoint[39].x))) + allPoint[39].x;
            //mid4 = new Point(allPoint[39].x,allPoint[121].y);
            mid4 = new Point(x0, y0);
        }
        else {
            y0 = allPoint[121].y;
            x0 = (int) ((float) (y0 - allPoint[13].y) / ((float) (allPoint[39].y - allPoint[13].y) / (float) (allPoint[39].x - allPoint[13].x))) + allPoint[13].x;
            //mid4 = new Point(allPoint[39].x,allPoint[121].y);
            mid4 = new Point(x0, y0);
        }

        if(allPoint[116].y >allPoint[57].y) {
            points.add(allPoint[0]);
            points.add(mid);
            points.add(allPoint[134]);
            points.add(allPoint[111]);
            points.add(allPoint[28]);
            points.add(allPoint[113]);
            points.add(allPoint[29]);
            points.add(allPoint[114]);
            points.add(allPoint[30]);
            points.add(allPoint[115]);
            points.add(allPoint[31]);
            points.add(allPoint[116]);
            points.add(mid3);
            points.add(allPoint[68]);
            points.add(allPoint[79]);
            points.add(allPoint[90]);
            points.add(allPoint[101]);
            points.add(allPoint[112]);
            points.add(allPoint[123]);
            points.add(allPoint[44]);
            points.add(allPoint[43]);
            points.add(allPoint[42]);
            points.add(allPoint[41]);
            points.add(allPoint[40]);
            points.add(mid4);
            points.add(allPoint[121]);
            points.add(allPoint[38]);
            points.add(allPoint[120]);
            points.add(allPoint[37]);
            points.add(allPoint[119]);
            points.add(allPoint[36]);
            points.add(allPoint[118]);
            points.add(allPoint[34]);
            points.add(allPoint[117]);
            points.add(allPoint[141]);
            points.add(mid2);
            points.add(allPoint[2]);
            points.add(allPoint[15]);
            points.add(allPoint[127]);
            points.add(allPoint[14]);
            points.add(allPoint[126]);
            points.add(allPoint[12]);
            points.add(allPoint[125]);
            points.add(allPoint[11]);
            points.add(allPoint[124]);
            points.add(allPoint[10]);
            points.add(allPoint[122]);
            points.add(allPoint[9]);// points.add(allPoint[0]); points.add(allPoint[1]);
        }
        else
        {
            points.add(allPoint[0]);
            points.add(mid);
            points.add(allPoint[134]);
            points.add(allPoint[111]);
            points.add(allPoint[28]);
            points.add(allPoint[113]);
            points.add(allPoint[29]);
            points.add(allPoint[114]);
            points.add(allPoint[30]);
            points.add(allPoint[115]);
            points.add(allPoint[31]);
            points.add(allPoint[116]);
            points.add(mid3);
            points.add(allPoint[57]);
            points.add(allPoint[68]);
            points.add(allPoint[79]);
            points.add(allPoint[90]);
            points.add(allPoint[101]);
            points.add(allPoint[112]);
            points.add(allPoint[123]);
            points.add(allPoint[44]);
            points.add(allPoint[43]);
            points.add(allPoint[42]);
            points.add(allPoint[41]);
            points.add(allPoint[40]);
            points.add(allPoint[39]);
            points.add(mid4);
            points.add(allPoint[121]);
            points.add(allPoint[38]);
            points.add(allPoint[120]);
            points.add(allPoint[37]);
            points.add(allPoint[119]);
            points.add(allPoint[36]);
            points.add(allPoint[118]);
            points.add(allPoint[34]);
            points.add(allPoint[117]);
            points.add(allPoint[141]);
            points.add(mid2);
            points.add(allPoint[2]);
            points.add(allPoint[15]);
            points.add(allPoint[127]);
            points.add(allPoint[14]);
            points.add(allPoint[126]);
            points.add(allPoint[12]);
            points.add(allPoint[125]);
            points.add(allPoint[11]);
            points.add(allPoint[124]);
            points.add(allPoint[10]);
            points.add(allPoint[122]);
            points.add(allPoint[9]);// points.add(allPoint[0]); points.add(allPoint[1]);
        }

        facePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
//            Point p1 = points.get(i);
//            facePath.moveTo(points.get(i).x,points.get(i).y);
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            facePath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
            //facePath.quadTo(p2.x,p2.y,p3.x,p3.y);
            //facePath.lineTo(p2.x,p2.y);

//            int w = Math.abs(p2.x - p1.x);
//            int h = Math.abs(p2.y - p1.y);
//            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);
//
//
//            if(p2.x >= p1.x)
//                facePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
//            else
//                facePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        faceRegion.setPath(facePath,new Region(0,0,reference.getWidth(),reference.getHeight()));
        drawRegion(canvas,faceRegion,skinPaint);
        points.clear();

        Region finalRegion = new Region(faceRegion);

        int gray_temp, red_temp, green_temp, blue_temp;
        int new_color;
        for(int i=0 ; i<gray.getWidth() ; i++) {
            for (int j = 0; j < gray.getHeight(); j++) {
                if (finalRegion.contains(i, j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));
                    red_temp = 241;
                    green_temp = 166;
                    blue_temp = 143;

                    red_temp = 158 + (int)((float)83 * ((float)(gray_temp-75)/(float)100));
                    green_temp = 80 + (int)((float)86 * ((float)(gray_temp-75)/(float)100));
                    blue_temp = 68 + (int)((float)75 * ((float)(gray_temp-75)/(float)100));

                    if(gray_temp < 75) {
                        red_temp = 128;
                        green_temp = 80;
                        blue_temp = 68;
                    }
                    else if(gray_temp >= 75 && gray_temp < 85) {
                        red_temp = 143;
                        green_temp = 89;
                        blue_temp = 77;
                    }
                    else if(gray_temp >= 85 && gray_temp < 95) {
                        red_temp = 151;
                        green_temp = 99;
                        blue_temp = 85;
                    }
                    else if(gray_temp >=95 && gray_temp < 105) {
                        red_temp = 159;
                        green_temp = 109;
                        blue_temp = 93;
                    }
                    else if(gray_temp >= 105 && gray_temp < 115) {
                        red_temp = 167;
                        green_temp = 119;
                        blue_temp = 101;
                    }
                    else if(gray_temp >= 115 && gray_temp < 125) {
                        red_temp = 175;
                        green_temp = 129;
                        blue_temp = 109;
                    }
                    else if(gray_temp >= 125 && gray_temp < 135) {
                        red_temp = 183;
                        green_temp = 139;
                        blue_temp = 117;
                    }
                    else if(gray_temp >= 135 && gray_temp < 145) {
                        red_temp = 191;
                        green_temp = 149;
                        blue_temp = 125;
                    }
                    else if(gray_temp >= 145 && gray_temp < 155) {
                        red_temp = 199;
                        green_temp = 159;
                        blue_temp = 133;
                    }
                    else if(gray_temp >= 155 && gray_temp < 165) {
                        red_temp = 202;
                        green_temp = 161;
                        blue_temp = 135;
                    }
                    else if(gray_temp >= 165 && gray_temp < 175) {
                        red_temp = 205;
                        green_temp = 163;
                        blue_temp = 137;
                    }
                    else if(gray_temp >= 175 && gray_temp < 185) {
                        red_temp = 208;
                        green_temp = 165;
                        blue_temp = 139;
                    }
                    else{
                        red_temp = 211;
                        green_temp = 166;
                        blue_temp = 143;
                    }






                    if(red_temp >= 255)
                        red_temp = 255;

                    if(green_temp >= 255)
                        green_temp = 255;

                    if(blue_temp >= 255)
                        blue_temp = 255;


                    new_color = Color.rgb(red_temp, green_temp, blue_temp);

                    dst.setPixel(i, j, new_color);

                }
            }
        }

        // ========================================================================================= //
        // ========================================================================================= //
        // =============================     耳朵/眉毛     ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //
        Paint skinPaint1 = newPaintLine(255,180,140,1, Paint.Style.FILL);
        // 左耳
        ear_shadow1 = new Point(allPoint[111].x,allPoint[111].y+(allPoint[116].y - allPoint[111].y)/6);
        ear_shadow2 = new Point(allPoint[113].x + Math.abs(allPoint[0].x - allPoint[113].x)/3,allPoint[113].y);
        ear_shadow3 = new Point(allPoint[114].x + Math.abs(allPoint[0].x - allPoint[114].x)/3,allPoint[114].y);
        ear_shadow4 = new Point(allPoint[115].x + Math.abs(allPoint[0].x - allPoint[115].x)/3,allPoint[115].y);
        ear_shadow5 = new Point(allPoint[116].x,allPoint[116].y-(allPoint[116].y - allPoint[111].y)/6);
        mid = new Point(allPoint[1].x,allPoint[113].y);
        points.add(ear_shadow1);points.add(ear_shadow2);points.add(ear_shadow3);points.add(ear_shadow4);points.add(ear_shadow5);
        points.add(allPoint[46]);points.add(mid);points.add(ear_shadow1);
        //drawCurve(canvas,points,shadowPaint,false);
        points.clear();
        // 右耳
        ear_shadow1 = new Point(allPoint[117].x,allPoint[117].y+(allPoint[121].y - allPoint[117].y)/6);
        ear_shadow2 = new Point(allPoint[118].x - Math.abs(allPoint[118].x - allPoint[24].x)/3,allPoint[118].y);
        ear_shadow3 = new Point(allPoint[119].x - Math.abs(allPoint[119].x - allPoint[24].x)/3,allPoint[119].y);
        ear_shadow4 = new Point(allPoint[120].x - Math.abs(allPoint[120].x - allPoint[24].x)/3,allPoint[120].y);
        ear_shadow5 = new Point(allPoint[121].x,allPoint[121].y-(allPoint[121].y - allPoint[117].y)/6);
        mid = new Point(allPoint[24].x,allPoint[118].y);
        points.add(ear_shadow1);points.add(ear_shadow2);points.add(ear_shadow3);points.add(ear_shadow4);points.add(ear_shadow5);
        points.add(allPoint[13]);points.add(mid);points.add(ear_shadow1);
        //drawCurve(canvas,points,shadowPaint,false);
        points.clear();
        // 左眉毛
        points.add(allPoint[45]); points.add(allPoint[47]); points.add(allPoint[48]); points.add(allPoint[49]);
        points.add(allPoint[50]); points.add(allPoint[51]); points.add(allPoint[52]); points.add(allPoint[53]);points.add(allPoint[45]); points.add(allPoint[47]);
        leftEyebrowRegion.setPath(leftEyebrowPath,new Region(allPoint[45].x,allPoint[48].y,allPoint[50].x,(allPoint[52].y + allPoint[130].y)/2));
        //drawCurve(canvas,points,eyeBrowPaint,true);
        points.clear();


        // 右眉毛
        points.add(allPoint[54]); points.add(allPoint[55]); points.add(allPoint[56]); points.add(allPoint[58]);
        points.add(allPoint[59]); points.add(allPoint[60]); points.add(allPoint[61]); points.add(allPoint[54]); points.add(allPoint[55]);
        rightEyebrowRegion.setPath(rightEyebrowPath,new Region(allPoint[54].x,allPoint[56].y,allPoint[59].x,(allPoint[61].y + allPoint[85].y)/2));
        //drawCurve(canvas,points,eyeBrowPaint,true);
        points.clear();





        // 左眉毛
        points.add(allPoint[45]); points.add(allPoint[47]); points.add(allPoint[48]); points.add(allPoint[49]);
        points.add(allPoint[50]); points.add(allPoint[51]); points.add(allPoint[52]); points.add(allPoint[53]);points.add(allPoint[45]); points.add(allPoint[47]);

        leftEyebrowPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            leftEyebrowPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }
        leftEyebrowRegion.setPath(leftEyebrowPath,new Region(allPoint[45].x,allPoint[48].y,allPoint[50].x,(allPoint[52].y + allPoint[130].y)/2));
        points.clear();

        Region finalleftEyebrowRegion = new Region(leftEyebrowRegion);

        int a = 50,b = 10;

        for(int i=0 ; i<gray.getWidth() ; i++) {
            for (int j = 0; j < gray.getHeight(); j++) {
                if (finalleftEyebrowRegion.contains(i, j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));

                    if(gray_temp < 75) {
                        red_temp = a;
                    }
                    else if(gray_temp >= 75 && gray_temp < 85) {
                        red_temp = a + b;
                    }
                    else if(gray_temp >= 85 && gray_temp < 95) {
                        red_temp = a + 2 * b;
                    }
                    else if(gray_temp >=95 && gray_temp < 105) {
                        red_temp = a + 3 * b;
                    }
                    else if(gray_temp >= 105 && gray_temp < 115) {
                        red_temp = a + 4 * b;
                    }
                    else if(gray_temp >= 115 && gray_temp < 125) {
                        red_temp = a + 5 * b;
                    }
                    else if(gray_temp >= 125 && gray_temp < 135) {
                        red_temp = a + 6 * b;
                    }
                    else if(gray_temp >= 135 && gray_temp < 145) {
                        red_temp = a + 7 * b;
                    }
                    else if(gray_temp >= 145 && gray_temp < 155) {
                        red_temp = a + 8 * b;
                    }
                    else if(gray_temp >= 155 && gray_temp < 165) {
                        red_temp = a + 9 * b;
                    }
                    else if(gray_temp >= 165 && gray_temp < 175) {
                        red_temp = a + 10 * b;
                    }
                    else if(gray_temp >= 175 && gray_temp < 185) {
                        red_temp = a + 11 * b;
                    }
                    else{
                        red_temp = a + 12 * b;
                    }

                    if(red_temp >= 255)
                        red_temp = 255;

                    new_color = Color.rgb(red_temp, red_temp, red_temp);

                    dst.setPixel(i, j, new_color);

                }
            }
        }


        // 右眉毛
        points.add(allPoint[54]); points.add(allPoint[55]); points.add(allPoint[56]); points.add(allPoint[58]);
        points.add(allPoint[59]); points.add(allPoint[60]); points.add(allPoint[61]); points.add(allPoint[54]); points.add(allPoint[55]);

        rightEyebrowPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            rightEyebrowPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }

        rightEyebrowRegion.setPath(rightEyebrowPath,new Region(allPoint[54].x,allPoint[56].y,allPoint[59].x,(allPoint[61].y + allPoint[85].y)/2));
        points.clear();

        Region finalrightEyebrowRegion = new Region(rightEyebrowRegion);

        for(int i=0 ; i<gray.getWidth() ; i++) {
            for (int j = 0; j < gray.getHeight(); j++) {
                if (finalrightEyebrowRegion.contains(i, j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));

                    if(gray_temp < 75) {
                        red_temp = a;
                    }
                    else if(gray_temp >= 75 && gray_temp < 85) {
                        red_temp = a + b;
                    }
                    else if(gray_temp >= 85 && gray_temp < 95) {
                        red_temp = a + 2 * b;
                    }
                    else if(gray_temp >=95 && gray_temp < 105) {
                        red_temp = a + 3 * b;
                    }
                    else if(gray_temp >= 105 && gray_temp < 115) {
                        red_temp = a + 4 * b;
                    }
                    else if(gray_temp >= 115 && gray_temp < 125) {
                        red_temp = a + 5 * b;
                    }
                    else if(gray_temp >= 125 && gray_temp < 135) {
                        red_temp = a + 6 * b;
                    }
                    else if(gray_temp >= 135 && gray_temp < 145) {
                        red_temp = a + 7 * b;
                    }
                    else if(gray_temp >= 145 && gray_temp < 155) {
                        red_temp = a + 8 * b;
                    }
                    else if(gray_temp >= 155 && gray_temp < 165) {
                        red_temp = a + 9 * b;
                    }
                    else if(gray_temp >= 165 && gray_temp < 175) {
                        red_temp = a + 10 * b;
                    }
                    else if(gray_temp >= 175 && gray_temp < 185) {
                        red_temp = a + 11 * b;
                    }
                    else{
                        red_temp = a + 12 * b;
                    }

                    if(red_temp >= 255)
                        red_temp = 255;

                    new_color = Color.rgb(red_temp, red_temp, red_temp);

                    dst.setPixel(i, j, new_color);

                }
            }
        }
        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     鼻子      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //
        points.add(allPoint[69]); points.add(allPoint[70]); points.add(allPoint[18]); points.add(allPoint[71]);
        points.add(allPoint[19]); points.add(allPoint[73]); points.add(allPoint[72]); points.add(allPoint[66]);
        points.add(allPoint[17]); points.add(allPoint[64]); points.add(allPoint[63]); points.add(allPoint[16]);
        points.add(allPoint[65]); points.add(allPoint[69]);

        nosePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i=1 ; i < points.size() ; ++i){
            nosePath.lineTo(points.get(i).x,points.get(i).y);
        }
//        for(int i = 0 ; i < points.size() - 1 ; ++i){
//            Point p1 = points.get(i);
//            Point p2 = points.get(i+1);
//            int w = Math.abs(p2.x - p1.x);
//            int h = Math.abs(p2.y - p1.y);
//            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);
//
//
//            if(p2.x >= p1.x)
//                nosePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
//            else
//                nosePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
//        }
        noseRegion.setPath(nosePath,new Region(NoseLeftPoint.x,allPoint[64].y,NoseRightPoint.x,NoseLowPoint.y));
        //drawCurve(canvas,points,nosePaint,false);
        points.clear();
        // 鼻孔
        float tmpH = allPoint[71].y - allPoint[67].y;
        /*canvas.drawOval(allPoint[70].x,allPoint[70].y - tmpH/10,allPoint[18].x,allPoint[70].y,profilePaint);
        canvas.drawOval(allPoint[19].x,allPoint[19].y - tmpH/10,allPoint[73].x,allPoint[19].y,profilePaint);*/
        Bitmap bitmap1 = BitmapFactory.decodeResource(getResources(), R.drawable.nose);
        Bitmap resizedBitmap1 = Bitmap.createScaledBitmap(bitmap1, allPoint[73].x - allPoint[70].x, (int) ((allPoint[73].x - allPoint[70].x)*0.3), false);
        canvas.drawBitmap(resizedBitmap1, allPoint[70].x,allPoint[70].y - tmpH/3 , profilePaint);

        //right nose shadow
        /*points.add(new Point(allPoint[64].x +10, allPoint[64].y));
        points.add(new Point(allPoint[17].x +10, allPoint[17].y));
        points.add(new Point(allPoint[66].x +10, allPoint[66].y));
        points.add(new Point(allPoint[72].x +10, allPoint[72].y));*/
        points.add(new Point(allPoint[64].x +2, allPoint[64].y));
        points.add(new Point(allPoint[17].x +2, allPoint[17].y));
        points.add(new Point(allPoint[66].x +2, allPoint[66].y));
        points.add(new Point(allPoint[72].x +10, allPoint[72].y));

        /*points.add(new Point(allPoint[64].x , allPoint[64].y));
        points.add(new Point(allPoint[64].x , allPoint[17].y));
        points.add(new Point(allPoint[64].x , allPoint[66].y));
        points.add(new Point(allPoint[64].x +10 , allPoint[72].y));
        points.add(new Point(allPoint[72].x, allPoint[72].y));*/
        //drawCurve(canvas, points, shadowPaint,true);
        points.clear();
        //left nose shadow
        points.add(new Point(allPoint[63].x -4, allPoint[63].y));
        points.add(new Point(allPoint[16].x -2, allPoint[16].y));
        points.add(new Point(allPoint[65].x -2, allPoint[65].y));
        points.add(new Point(allPoint[69].x -5, allPoint[69].y-7));
        //drawCurve(canvas, points, shadowPaint,false);
        points.clear();
        //mouth shadow
        points.add(new Point(allPoint[104].x, allPoint[104].y));
        points.add(new Point(allPoint[103].x, allPoint[103].y+10));
        points.add(new Point(allPoint[102].x, allPoint[102].y+20));
        points.add(new Point(allPoint[100].x, allPoint[100].y+10));
        points.add(new Point(allPoint[99].x, allPoint[99].y));
        //drawCurve(canvas, points, shadowPaint,false);
        points.clear();
        //right eye shadow
        points.add(new Point(allPoint[83].x, allPoint[83].y +10));
        points.add(new Point(allPoint[91].x, allPoint[91].y +10));
        points.add(new Point(allPoint[89].x, allPoint[89].y +10));
        points.add(new Point(allPoint[88].x, allPoint[88].y +10));
        points.add(new Point(allPoint[87].x, allPoint[87].y +10));
        //drawCurve(canvas, points, shadowPaint,false);
        points.clear();
        //left eye shadow
        points.add(new Point(allPoint[78].x, allPoint[78].y +10));
        points.add(new Point(allPoint[80].x, allPoint[80].y +10));
        points.add(new Point(allPoint[81].x, allPoint[81].y +10));
        points.add(new Point(allPoint[82].x, allPoint[82].y +10));
        points.add(new Point(allPoint[74].x, allPoint[74].y +10));
        //drawCurve(canvas, points, shadowPaint,false);
        points.clear();
        //right upper eyelid shadow
        points.add(new Point(allPoint[3].x, allPoint[3].y -10));
        points.add(new Point(allPoint[4].x, allPoint[4].y -10));
        points.add(new Point(allPoint[5].x, allPoint[5].y -10));
        points.add(new Point(allPoint[6].x, allPoint[6].y -10));
        points.add(new Point(allPoint[7].x, allPoint[7].y -10));
        points.add(new Point(allPoint[8].x, allPoint[8].y -10));
        //drawCurve(canvas, points, shadowPaint,false);
        points.clear();
        //left upper eyelid shadow
        points.add(new Point(allPoint[128].x, allPoint[128].y -10));
        points.add(new Point(allPoint[129].x, allPoint[129].y -10));
        points.add(new Point(allPoint[130].x, allPoint[130].y -10));
        points.add(new Point(allPoint[131].x, allPoint[131].y -10));
        points.add(new Point(allPoint[132].x, allPoint[132].y -10));
        points.add(new Point(allPoint[133].x, allPoint[133].y -10));
        //drawCurve(canvas, points, shadowPaint,false);
        points.clear();

        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     眼睛      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //
        // 眼球畫筆
        Paint eyePaint = newPaintLine("#B17455",(float)FaceWidth/200, Paint.Style.FILL);//瞳孔底色
        eyePaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));

        Paint eyePaint1 = newPaintLine("#4E332C",(float)FaceWidth/200, Paint.Style.FILL);//虹膜
        eyePaint1.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));

        Paint eyePaint2 = newPaintLine("#FFFFFF",(float)FaceWidth/200, Paint.Style.FILL);//光點1(右)
        eyePaint2.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));

        Paint eyePaint3 = newPaintLine("#D7B5A9",(float)FaceWidth/200, Paint.Style.FILL);//光點2(左)
        eyePaint3.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));

        Bitmap eye = Bitmap.createBitmap(dst.getWidth(),dst.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas tmpCanvas = new Canvas(eye);


        // 左眼Region
        points.add(allPoint[74]); points.add(allPoint[82]); points.add(allPoint[81]); points.add(allPoint[80]);
        points.add(allPoint[78]); points.add(allPoint[77]); points.add(allPoint[76]); points.add(allPoint[75]);
        points.add(allPoint[74]);
        leftEyePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                leftEyePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                leftEyePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        leftEyeRegion.setPath(leftEyePath,new Region(EyeLeftLeftPoint.x,EyeLeftTopPoint.y,EyeLeftRightPoint.x,EyeLeftDownPoint.y));
        drawCurve(tmpCanvas,points,whitePaint,false);
        points.clear();
        // 右眼Region
        points.add(allPoint[83]); points.add(allPoint[91]); points.add(allPoint[89]); points.add(allPoint[88]);
        points.add(allPoint[87]); points.add(allPoint[86]); points.add(allPoint[85]); points.add(allPoint[84]);
        points.add(allPoint[83]);
        rightEyePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                rightEyePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                rightEyePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        rightEyeRegion.setPath(rightEyePath,new Region(EyeRightLeftPoint.x,EyeRightTopPoint.y,EyeRightRightPoint.x,EyeRightDownPoint.y));
        drawCurve(tmpCanvas,points,whitePaint,false);
        points.clear();

        float radius = (float)(allPoint[23].x-allPoint[22].x)/2 > (float)(allPoint[26].x-allPoint[25].x)/2? (float)(allPoint[23].x-allPoint[22].x)/2 :(float)(allPoint[26].x-allPoint[25].x)/2;
        // 左眼球
        /*path.addCircle((allPoint[22].x+allPoint[23].x)/2,(allPoint[22].y+allPoint[23].y)/2-radius/5,radius,Path.Direction.CW);
        tmpCanvas.drawPath(path,eyePaint);
        path.reset();
        path.addCircle((allPoint[22].x+allPoint[23].x)/2,(allPoint[22].y+allPoint[23].y)/2-radius/5,radius/2,Path.Direction.CW);
        tmpCanvas.drawPath(path,eyePaint1);
        path.reset();
        path.addCircle((allPoint[22].x+allPoint[23].x)/2 + radius/2 ,(allPoint[22].y+allPoint[23].y)/2-radius/5,radius/5,Path.Direction.CW);
        tmpCanvas.drawPath(path,eyePaint2);
        path.reset();
        path.addCircle((allPoint[22].x+allPoint[23].x)/2 - radius/2 ,(allPoint[22].y+allPoint[23].y)/2,radius/5,Path.Direction.CW);
        tmpCanvas.drawPath(path,eyePaint3);
        path.reset();*/

        // 右眼球
        /*path.addCircle((allPoint[25].x+allPoint[26].x)/2,(allPoint[25].y+allPoint[26].y)/2-radius/5,radius,Path.Direction.CW);
        tmpCanvas.drawPath(path,eyePaint);
        path.reset();
        path.addCircle((allPoint[25].x+allPoint[26].x)/2,(allPoint[25].y+allPoint[26].y)/2-radius/5,radius/2,Path.Direction.CW);
        tmpCanvas.drawPath(path,eyePaint1);
        path.reset();
        path.addCircle((allPoint[25].x+allPoint[26].x)/2 + radius/2,(allPoint[25].y+allPoint[26].y)/2-radius/5,radius/5,Path.Direction.CW);
        tmpCanvas.drawPath(path,eyePaint2);
        path.reset();
        path.addCircle((allPoint[25].x+allPoint[26].x)/2 - radius/2,(allPoint[25].y+allPoint[26].y)/2,radius/5,Path.Direction.CW);
        tmpCanvas.drawPath(path,eyePaint3);
        path.reset();*/

        Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.eye);//畫眼球
        Bitmap resizedBitmap = Bitmap.createScaledBitmap(bitmap, (int)(radius*2.7), (int)(radius*2.7), false);
        tmpCanvas.drawBitmap(resizedBitmap, (allPoint[22].x+allPoint[23].x)/2 - radius-radius/3,(allPoint[22].y+allPoint[23].y)/2-radius-radius/3, eyePaint2);
        tmpCanvas.drawBitmap(resizedBitmap, (allPoint[25].x+allPoint[26].x)/2 - radius-radius/2,(allPoint[25].y+allPoint[26].y)/2-radius-radius/3, eyePaint2);

        Paint p = new Paint();
        canvas.drawBitmap(eye,0,0,p);
        // 左雙眼皮線
        points.add(allPoint[133]); points.add(allPoint[132]); points.add(allPoint[131]); points.add(allPoint[130]);
        points.add(allPoint[129]); //points.add(allPoint[128]);
        //drawCurve(canvas,points,eyeLidPaint,false);
        points.clear();
        points.add(allPoint[74]); points.add(allPoint[82]); points.add(allPoint[81]);
        //drawCurve(canvas,points,eyeLidPaint1,false);
        points.clear();
        // 右雙眼皮線
        points.add(allPoint[3]);
        points.add(allPoint[4]); points.add(allPoint[5]); points.add(allPoint[6]);points.add(allPoint[7]); points.add(allPoint[8]);
        //drawCurve(canvas,points,eyeLidPaint,false);
        points.clear();
        points.add(allPoint[87]); points.add(allPoint[88]); points.add(allPoint[89]);
        //drawCurve(canvas,points,eyeLidPaint1,false);
        points.clear();


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     嘴唇      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //

        // 嘴唇(外)  80 83 86 90 左上右下
        tmpH = (allPoint[102].y - allPoint[109].y)/4;
        mid = new Point((allPoint[109].x + allPoint[102].x)/2,(allPoint[109].y + allPoint[102].y)/2);
        for(int y = (int)(mid.y - tmpH) ; y < mid.y + tmpH ; ++y){
            for(int x = (int)(mid.x - tmpH) ; x < mid.x + tmpH ; ++x){
                int pixel = reference.getPixel(x,y);
                sumR += Color.red(pixel);
                sumG += Color.green(pixel);
                sumB += Color.blue(pixel);
                ++cnt;
            }
        }
        //Paint lipPaint = newPaintLine(sumR/cnt,sumG/cnt,sumB/cnt,1, Paint.Style.FILL);
        Paint lipPaint = newPaintLine("#EA797C",(float)FaceWidth/200, Paint.Style.FILL);
        points.add(allPoint[92]); points.add(allPoint[104]); points.add(allPoint[103]); points.add(allPoint[102]);
        points.add(allPoint[100]); points.add(allPoint[99]); points.add(allPoint[98]); points.add(allPoint[97]);
        points.add(allPoint[96]); points.add(allPoint[95]); points.add(allPoint[93]); points.add(allPoint[94]);
        points.add(allPoint[92]);

        mouthPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                mouthPath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                mouthPath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        mouthRegion.setPath(mouthPath,new Region(MouthLeftPoint.x,MouthPeak.y,MouthRightPoint.x,allPoint[102].y));
        //drawCurve(canvas,points,lipPaint,false);
        points.clear();

        Region finalmouthRegion = new Region(mouthRegion);

        for(int i=0 ; i<gray.getWidth() ; i++) {
            for (int j = 0; j < gray.getHeight(); j++) {
                if (finalmouthRegion.contains(i, j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));

                    if(gray_temp < 75) {
                        red_temp = 99;
                        green_temp = 31;
                        blue_temp = 34;
                    }
                    else if(gray_temp >= 75 && gray_temp < 85) {
                        red_temp = 114;
                        green_temp = 41;
                        blue_temp = 44;
                    }
                    else if(gray_temp >= 85 && gray_temp < 95) {
                        red_temp = 129;
                        green_temp = 51;
                        blue_temp = 54;
                    }
                    else if(gray_temp >=95 && gray_temp < 105) {
                        red_temp = 144;
                        green_temp = 61;
                        blue_temp = 64;
                    }
                    else if(gray_temp >= 105 && gray_temp < 115) {
                        red_temp = 159;
                        green_temp = 71;
                        blue_temp = 74;
                    }
                    else if(gray_temp >= 115 && gray_temp < 125) {
                        red_temp = 174;
                        green_temp = 81;
                        blue_temp = 84;
                    }
                    else if(gray_temp >= 125 && gray_temp < 135) {
                        red_temp = 189;
                        green_temp = 91;
                        blue_temp = 94;
                    }
                    else if(gray_temp >= 135 && gray_temp < 145) {
                        red_temp = 204;
                        green_temp = 101;
                        blue_temp = 104;
                    }
                    else if(gray_temp >= 145 && gray_temp < 155) {
                        red_temp = 219;
                        green_temp = 111;
                        blue_temp = 114;
                    }
                    else{
                        red_temp = 234;
                        green_temp = 121;
                        blue_temp = 124;
                    }






                    if(red_temp >= 255)
                        red_temp = 255;

                    if(green_temp >= 255)
                        green_temp = 255;

                    if(blue_temp >= 255)
                        blue_temp = 255;

                    new_color = Color.rgb(red_temp, green_temp, blue_temp);

                    dst.setPixel(i, j, new_color);

                }
            }
        }



        float lipHeight = (float)(allPoint[102].y - allPoint[95].y);
        float lipWidth = (float)(allPoint[98].x - allPoint[92].x);
        if( (allPoint[109].y - allPoint[106].y) > 0.10 * lipWidth) {  // 如果嘴巴打開程度 > 5%嘴唇高度 就畫出來
            // 嘴唇(內)
            // 處理牙齒部分 // 80 86分五等分
            Bitmap lip = Bitmap.createBitmap(dst.getWidth(),dst.getHeight(), Bitmap.Config.ARGB_8888);
            tmpCanvas = new Canvas(lip);
            // 畫出牙齒(白色)
            points.add(allPoint[92]); points.add(allPoint[105]); points.add(allPoint[106]); points.add(allPoint[107]);
            points.add(allPoint[98]); points.add(allPoint[108]); points.add(allPoint[109]); points.add(allPoint[110]);
            drawCurve(tmpCanvas, points, whitePaint, true);
            // 畫出牙齒間隔(黑色)
            float space = ((float)allPoint[98].x - (float)allPoint[92].x)/6;
            for(int i=1 ; i <= 5 ; ++i)
                tmpCanvas.drawLine(allPoint[92].x + i*space,allPoint[95].y,allPoint[92].x + i*space,allPoint[102].y,eyePaint);
            canvas.drawBitmap(lip,0,0,p);

            points.clear();

            if( (allPoint[109].y - allPoint[106].y) > 0.20 * lipWidth) {
                Paint toothline = newPaintLine("#B17455", (float) FaceWidth / 150, Paint.Style.STROKE);

                Point middle1 = new Point((allPoint[105].x + allPoint[110].x) / 2, ( allPoint[105].y +2 * allPoint[110].y) / 3);
                Point middle2 = new Point((allPoint[106].x + allPoint[109].x) / 2, ( allPoint[106].y + 2 *allPoint[109].y) / 3);
                Point middle3 = new Point((allPoint[107].x + allPoint[108].x) / 2, ( allPoint[107].y +2 * allPoint[108].y) / 3);

                points.add(allPoint[92]);
                points.add(middle1);
                points.add(middle2);
                points.add(middle3);
                points.add(allPoint[98]);
                drawCurve(canvas, points, toothline, false);
                points.clear();
            }
        }
        else {
            // 嘴唇線
            points.add(allPoint[92]); points.add(allPoint[109]); points.add(allPoint[98]);
            drawCurve(canvas, points, lipLinePaint, false);
            points.clear();
        }

        // 臉 排除 雙眼、鼻子、嘴唇剩下的地方
 /*       Region finalRegion = new Region(faceRegion);  // copy faceRegion
        finalRegion.op(leftEyeRegion, Region.Op.XOR);
        finalRegion.op(rightEyeRegion, Region.Op.XOR);
        finalRegion.op(noseRegion, Region.Op.XOR);
        finalRegion.op(mouthRegion, Region.Op.XOR);
        finalRegion.op(leftEyebrowRegion, Region.Op.XOR);
        finalRegion.op(rightEyebrowRegion, Region.Op.XOR);*/
//        drawRegion(canvas,finalRegion,whitePaint);

/*        int gray_temp, red_temp, green_temp, blue_temp;
        int new_color;
        float[] hsv = new float[3];
        for(int i=0 ; i<gray.getWidth() ; i++) {
            for (int j = 0; j < gray.getHeight(); j++) {
                if(finalRegion.contains(i,j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));
                    red_temp = Color.red(dst.getPixel(i, j));
                    green_temp = Color.green(dst.getPixel(i, j));
                    blue_temp = Color.blue(dst.getPixel(i, j));
                    Color.RGBToHSV(red_temp, green_temp, blue_temp, hsv);


        if(hsv[2] > 1)
            hsv[2] = 1;

        if(hsv[2] < 0)
            hsv[2] = 0;
        if(gray_temp < 75)
            new_color = Color.rgb(233,181,146);
        else
            new_color = Color.rgb(red_temp,green_temp,blue_temp);

        dst.setPixel(i,j,new_color);
                }
                hsv[2] = 0;
            }
        }
*/
        return dst;
    }
    private void drawFake(Bitmap src,Bitmap reference){
        Canvas canvas = new Canvas(src);
        canvas.drawARGB(0,0,0,0);
        Bitmap gray = gray(reference,255);

        Paint blackPaint = newPaintLine("#000000",1, Paint.Style.FILL);
        Paint whitePaint = newPaintLine("#ffffff",1, Paint.Style.FILL);
        Paint profilePaint = newPaintLine("#000000",(float)FaceWidth/50, Paint.Style.STROKE);
        Paint teethPaint = newPaintLine("#fefbe3",1, Paint.Style.FILL);
        Paint teethGapPaint = newPaintLine("#c8c7bd",(float)FaceWidth/200, Paint.Style.FILL);
        teethGapPaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));


        Paint eyeBrowPaint = newPaintLine("#533130",1, Paint.Style.FILL);
        Paint eyeLidPaint = newPaintLine("#3e3b40",(float)FaceWidth/100, Paint.Style.STROKE);
        Paint lipLinePaint = newPaintLine("#810404",(float)FaceWidth/100, Paint.Style.STROKE);


        ArrayList<Point> points = new ArrayList<>();
        Path path = new Path();
        Point mid,mid2,mid3,mid4;

        Region faceRegion = new Region();
        Path facePath = new Path();

        Region leftEyeRegion = new Region();
        Path leftEyePath = new Path();

        Region rightEyeRegion = new Region();
        Path rightEyePath = new Path();

        Region noseRegion = new Region();
        Path nosePath = new Path();

        Region mouthRegion = new Region();
        Path mouthPath = new Path();

        Region leftEyebrowRegion = new Region();
        Path leftEyebrowPath = new Path();


        Region rightEyebrowRegion = new Region();
        Path rightEyebrowPath = new Path();


        int sumR = 0;
        int sumG = 0;
        int sumB = 0;
        int cnt = 0;
        for(int y = allPoint[67].y - FaceHeight/10 ; y < allPoint[67].y + 10 ; ++y){
            for(int x = allPoint[67].x - FaceWidth/10 ; x < allPoint[67].x + FaceWidth/10 ; ++x){
                int pixel = reference.getPixel(x,y);
                if(Color.green(pixel) - Color.blue(pixel) > 10) {
                    sumR += Color.red(pixel);
                    sumG += Color.green(pixel);
                    sumB += Color.blue(pixel);
                    ++cnt;
                }
            }
            Log.i("MAPPMSG","============");
        }
        if(cnt!=0) {
            sumR /= cnt;
            sumG /= cnt;
            sumB /= cnt;
        }else{
            int pixel = reference.getPixel(allPoint[67].x,allPoint[67].y);
            sumR = Color.red(pixel);
            sumG = Color.green(pixel);
            sumB = Color.blue(pixel);
        }

        Log.i("MAPPMSG","sumR: " + sumR);
        Log.i("MAPPMSG","sumG: " + sumG);
        Log.i("MAPPMSG","sumB: " + sumB);

        Paint shadowPaint = newPaintLine(sumR,sumG,sumB,1, Paint.Style.FILL); //d1cbcb
        sumR += 20;
        sumG += 20;
        sumB += 20;
        if(sumR > 255) sumR = 255;
        if(sumG > 255) sumG = 255;
        if(sumB > 255) sumB = 255;
        Paint skinPaint = newPaintLine(sumR,sumG,sumB,1, Paint.Style.FILL);


        sumR += 20;
        sumG += 20;
        sumB += 20;
        if(sumR > 255) sumR = 255;
        if(sumG > 255) sumG = 255;
        if(sumB > 255) sumB = 255;
        Paint nosePaint = newPaintLine(sumR,sumG,sumB,(float)FaceWidth/100, Paint.Style.STROKE);


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     臉型      ========================================= //
        // ========================================================================================= //
        // ========================================================================================= //
        int x0,y0;
        y0 = allPoint[134].y;
        x0 = (int)((float)(y0 - allPoint[1].y)/((float)(allPoint[0].y - allPoint[1].y)/(float)(allPoint[0].x - allPoint[1].x)))+allPoint[1].x;
        //mid = new Point(allPoint[0].x,allPoint[134].y);
        mid = new Point(x0,y0);

        y0 = allPoint[141].y;
        x0 = (int)((float)(y0 - allPoint[24].y)/((float)(allPoint[2].y - allPoint[24].y)/(float)(allPoint[2].x - allPoint[24].x)))+allPoint[24].x;
        //mid2 = new Point(allPoint[2].x,allPoint[141].y);
        mid2 = new Point(x0,y0);

        if(allPoint[116].y >allPoint[57].y)
        {
            y0 = allPoint[116].y;
            x0 = (int) ((float) (y0 - allPoint[57].y) / ((float) (allPoint[68].y - allPoint[57].y) / (float) (allPoint[68].x - allPoint[57].x))) + allPoint[57].x;
            //mid3 = new Point(allPoint[32].x,allPoint[116].y);
            mid3 = new Point(x0, y0);
        }
        else {
            y0 = allPoint[116].y;
            x0 = (int) ((float) (y0 - allPoint[46].y) / ((float) (allPoint[57].y - allPoint[46].y) / (float) (allPoint[57].x - allPoint[46].x))) + allPoint[46].x;
            //mid3 = new Point(allPoint[32].x,allPoint[116].y);
            mid3 = new Point(x0, y0);
        }

        if(allPoint[121].y > allPoint[39].y)
        {
            y0 = allPoint[121].y;
            x0 = (int) ((float) (y0 - allPoint[39].y) / ((float) (allPoint[40].y - allPoint[39].y) / (float) (allPoint[40].x - allPoint[39].x))) + allPoint[39].x;
            //mid4 = new Point(allPoint[39].x,allPoint[121].y);
            mid4 = new Point(x0, y0);
        }
        else {
            y0 = allPoint[121].y;
            x0 = (int) ((float) (y0 - allPoint[13].y) / ((float) (allPoint[39].y - allPoint[13].y) / (float) (allPoint[39].x - allPoint[13].x))) + allPoint[13].x;
            //mid4 = new Point(allPoint[39].x,allPoint[121].y);
            mid4 = new Point(x0, y0);
        }

        if(allPoint[116].y >allPoint[57].y) {
            points.add(allPoint[0]);
            points.add(mid);
            points.add(allPoint[134]);
            points.add(allPoint[111]);
            points.add(allPoint[28]);
            points.add(allPoint[113]);
            points.add(allPoint[29]);
            points.add(allPoint[114]);
            points.add(allPoint[30]);
            points.add(allPoint[115]);
            points.add(allPoint[31]);
            points.add(allPoint[116]);
            points.add(mid3);
            points.add(allPoint[68]);
            points.add(allPoint[79]);
            points.add(allPoint[90]);
            points.add(allPoint[101]);
            points.add(allPoint[112]);
            points.add(allPoint[123]);
            points.add(allPoint[44]);
            points.add(allPoint[43]);
            points.add(allPoint[42]);
            points.add(allPoint[41]);
            points.add(allPoint[40]);
            points.add(mid4);
            points.add(allPoint[121]);
            points.add(allPoint[38]);
            points.add(allPoint[120]);
            points.add(allPoint[37]);
            points.add(allPoint[119]);
            points.add(allPoint[36]);
            points.add(allPoint[118]);
            points.add(allPoint[34]);
            points.add(allPoint[117]);
            points.add(allPoint[141]);
            points.add(mid2);
            points.add(allPoint[2]);
            points.add(allPoint[15]);
            points.add(allPoint[127]);
            points.add(allPoint[14]);
            points.add(allPoint[126]);
            points.add(allPoint[12]);
            points.add(allPoint[125]);
            points.add(allPoint[11]);
            points.add(allPoint[124]);
            points.add(allPoint[10]);
            points.add(allPoint[122]);
            points.add(allPoint[9]);// points.add(allPoint[0]); points.add(allPoint[1]);
        }
        else
        {
            points.add(allPoint[0]);
            points.add(mid);
            points.add(allPoint[134]);
            points.add(allPoint[111]);
            points.add(allPoint[28]);
            points.add(allPoint[113]);
            points.add(allPoint[29]);
            points.add(allPoint[114]);
            points.add(allPoint[30]);
            points.add(allPoint[115]);
            points.add(allPoint[31]);
            points.add(allPoint[116]);
            points.add(mid3);
            points.add(allPoint[57]);
            points.add(allPoint[68]);
            points.add(allPoint[79]);
            points.add(allPoint[90]);
            points.add(allPoint[101]);
            points.add(allPoint[112]);
            points.add(allPoint[123]);
            points.add(allPoint[44]);
            points.add(allPoint[43]);
            points.add(allPoint[42]);
            points.add(allPoint[41]);
            points.add(allPoint[40]);
            points.add(allPoint[39]);
            points.add(mid4);
            points.add(allPoint[121]);
            points.add(allPoint[38]);
            points.add(allPoint[120]);
            points.add(allPoint[37]);
            points.add(allPoint[119]);
            points.add(allPoint[36]);
            points.add(allPoint[118]);
            points.add(allPoint[34]);
            points.add(allPoint[117]);
            points.add(allPoint[141]);
            points.add(mid2);
            points.add(allPoint[2]);
            points.add(allPoint[15]);
            points.add(allPoint[127]);
            points.add(allPoint[14]);
            points.add(allPoint[126]);
            points.add(allPoint[12]);
            points.add(allPoint[125]);
            points.add(allPoint[11]);
            points.add(allPoint[124]);
            points.add(allPoint[10]);
            points.add(allPoint[122]);
            points.add(allPoint[9]);// points.add(allPoint[0]); points.add(allPoint[1]);
        }

        facePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
//            Point p1 = points.get(i);
//            facePath.moveTo(points.get(i).x,points.get(i).y);
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            facePath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
            //facePath.quadTo(p2.x,p2.y,p3.x,p3.y);
            //facePath.lineTo(p2.x,p2.y);

//            int w = Math.abs(p2.x - p1.x);
//            int h = Math.abs(p2.y - p1.y);
//            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);
//
//
//            if(p2.x >= p1.x)
//                facePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
//            else
//                facePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        faceRegion.setPath(facePath,new Region(0,0,reference.getWidth(),reference.getHeight()));
        drawRegion(canvas,faceRegion,skinPaint);
        points.clear();

        // ========================================================================================= //
        // ========================================================================================= //
        // =============================     耳朵/眉毛     ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //

        // 左耳
        mid = new Point((allPoint[0].x + allPoint[1].x)/2,(allPoint[0].y + allPoint[1].y)/2);
        //points.add(mid); points.add(allPoint[111]); points.add(allPoint[113]); points.add(allPoint[114]);
        //points.add(allPoint[115]); points.add(allPoint[116]); points.add(allPoint[57]);
        points.add(mid);points.add(allPoint[111]);points.add(allPoint[28]);points.add(allPoint[113]);points.add(allPoint[29]);points.add(allPoint[114]);
        points.add(allPoint[30]);points.add(allPoint[115]);points.add(allPoint[31]);points.add(allPoint[116]);points.add(allPoint[57]);
        //drawCurve(canvas,points,skinPaint,false);
        points.clear();
        // 右耳
        mid = new Point((allPoint[2].x + allPoint[24].x)/2,(allPoint[2].y + allPoint[24].y)/2);
        //points.add(mid); points.add(allPoint[117]); points.add(allPoint[118]); points.add(allPoint[119]);
        //points.add(allPoint[120]); points.add(allPoint[121]); points.add(allPoint[39]);
        points.add(mid);points.add(allPoint[117]);points.add(allPoint[34]);points.add(allPoint[118]);points.add(allPoint[36]);points.add(allPoint[119]);
        points.add(allPoint[37]);points.add(allPoint[120]);points.add(allPoint[38]);points.add(allPoint[121]);points.add(allPoint[39]);
        //drawCurve(canvas,points,skinPaint,false);
        points.clear();
        // 左眉毛
        points.add(allPoint[45]); points.add(allPoint[47]); points.add(allPoint[48]); points.add(allPoint[49]);
        points.add(allPoint[50]); points.add(allPoint[51]); points.add(allPoint[52]); points.add(allPoint[53]);points.add(allPoint[45]); points.add(allPoint[47]);

        leftEyebrowPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            leftEyebrowPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }
/*
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                leftEyebrowPath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                leftEyebrowPath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        */
        leftEyebrowRegion.setPath(leftEyebrowPath,new Region(allPoint[45].x,allPoint[48].y,allPoint[50].x,(allPoint[52].y + allPoint[130].y)/2));
        //drawRegion(canvas,leftEyebrowRegion,eyeBrowPaint);
//        drawCurve(canvas,points,eyeBrowPaint,true);
        points.clear();
        // 右眉毛
        points.add(allPoint[54]); points.add(allPoint[55]); points.add(allPoint[56]); points.add(allPoint[58]);
        points.add(allPoint[59]); points.add(allPoint[60]); points.add(allPoint[61]); points.add(allPoint[54]); points.add(allPoint[55]);

        rightEyebrowPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            rightEyebrowPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
        }
        /*
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                rightEyebrowPath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                rightEyebrowPath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        */
        rightEyebrowRegion.setPath(rightEyebrowPath,new Region(allPoint[54].x,allPoint[56].y,allPoint[59].x,(allPoint[61].y + allPoint[85].y)/2));
        //drawRegion(canvas,rightEyebrowRegion,eyeBrowPaint);
//        drawCurve(canvas,points,eyeBrowPaint,true);
        points.clear();


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     鼻子      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //
        points.add(allPoint[69]); points.add(allPoint[70]); points.add(allPoint[18]); points.add(allPoint[71]);
        points.add(allPoint[19]); points.add(allPoint[73]); points.add(allPoint[72]); points.add(allPoint[66]);
        points.add(allPoint[17]); points.add(allPoint[64]); points.add(allPoint[63]); points.add(allPoint[16]);
        points.add(allPoint[65]); points.add(allPoint[69]);

        nosePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i=1 ; i < points.size() ; ++i){
            nosePath.lineTo(points.get(i).x,points.get(i).y);
        }
        noseRegion.setPath(nosePath,new Region(NoseLeftPoint.x,allPoint[64].y,NoseRightPoint.x,NoseLowPoint.y));
//        drawCurve(canvas,points,nosePaint,false);
        points.clear();
        // 鼻孔
//        float tmpH = allPoint[59].y - allPoint[55].y;
//        canvas.drawOval(allPoint[58].x,allPoint[58].y - tmpH/10,allPoint[18].x,allPoint[58].y,profilePaint);
//        canvas.drawOval(allPoint[19].x,allPoint[19].y - tmpH/10,allPoint[61].x,allPoint[19].y,profilePaint);


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     眼睛      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //
        // 眼球畫筆
        Paint eyePaint = newPaintLine("#000000",(float)FaceWidth/200, Paint.Style.FILL);
        eyePaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));

        Bitmap eye = Bitmap.createBitmap(src.getWidth(),src.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas tmpCanvas = new Canvas(eye);
        // 左眼Region
        points.add(allPoint[74]); points.add(allPoint[82]); points.add(allPoint[81]); points.add(allPoint[80]);
        points.add(allPoint[78]); points.add(allPoint[77]); points.add(allPoint[76]); points.add(allPoint[75]);
        points.add(allPoint[74]);

        leftEyePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                leftEyePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                leftEyePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        leftEyeRegion.setPath(leftEyePath,new Region(EyeLeftLeftPoint.x,EyeLeftTopPoint.y,EyeLeftRightPoint.x,EyeLeftDownPoint.y));
//        drawCurve(tmpCanvas,points,teethPaint,false);
        points.clear();
        // 右眼Region
        points.add(allPoint[83]); points.add(allPoint[91]); points.add(allPoint[89]); points.add(allPoint[88]);
        points.add(allPoint[87]); points.add(allPoint[86]); points.add(allPoint[85]); points.add(allPoint[84]);
        points.add(allPoint[83]);
        rightEyePath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            Point p1 = points.get(i);
            Point p2 = points.get(i+1);
            int w = Math.abs(p2.x - p1.x);
            int h = Math.abs(p2.y - p1.y);
            mid = new Point( (p1.x+p2.x)/2,(p1.y+p2.y)/2);

            if(p2.x >= p1.x)
                rightEyePath.quadTo(mid.x,mid.y + h/4,p2.x,p2.y);
            else
                rightEyePath.quadTo(mid.x,mid.y - h/4,p2.x,p2.y);
        }
        rightEyeRegion.setPath(rightEyePath,new Region(EyeRightLeftPoint.x,EyeRightTopPoint.y,EyeRightRightPoint.x,EyeRightDownPoint.y));
//        drawCurve(tmpCanvas,points,teethPaint,false);
        points.clear();

        float radius = (float)(allPoint[23].x-allPoint[22].x)/2 > (float)(allPoint[26].x-allPoint[25].x)/2? (float)(allPoint[23].x-allPoint[22].x)/2 :(float)(allPoint[26].x-allPoint[25].x)/2;
        radius *= 1.05;
        // 左眼球
        path.addCircle((allPoint[22].x+allPoint[23].x)/2,(allPoint[22].y+allPoint[23].y)/2,radius,Path.Direction.CW);
//        tmpCanvas.drawPath(path,eyePaint);
        path.reset();
        // 右眼球
        path.addCircle((allPoint[25].x+allPoint[26].x)/2,(allPoint[25].y+allPoint[26].y)/2,radius,Path.Direction.CW);
//        tmpCanvas.drawPath(path,eyePaint);
        path.reset();
        Paint p = new Paint();
//        canvas.drawBitmap(eye,0,0,p);
        /*
        // 左雙眼皮線
        points.add(allPoint[121]); points.add(allPoint[120]); points.add(allPoint[119]); points.add(allPoint[118]);
        points.add(allPoint[117]); points.add(allPoint[116]);
        drawCurve(canvas,points,eyeLidPaint,false);
        points.clear();
        // 右雙眼皮線
        points.add(allPoint[3]); points.add(allPoint[4]); points.add(allPoint[5]); points.add(allPoint[6]);
        points.add(allPoint[7]); points.add(allPoint[8]);
        drawCurve(canvas,points,eyeLidPaint,false);
        points.clear();
        */


        // ========================================================================================= //
        // ========================================================================================= //
        // ================================     嘴唇      ========================================== //
        // ========================================================================================= //
        // ========================================================================================= //

        // 嘴唇(外)  80 83 86 90 左上右下
        int tmpH = (allPoint[102].y - allPoint[109].y)/4;
        mid = new Point((allPoint[109].x + allPoint[102].x)/2,(allPoint[109].y + allPoint[102].y)/2);
        for(int y = (int)(mid.y - tmpH) ; y < mid.y + tmpH ; ++y){
            for(int x = (int)(mid.x - tmpH) ; x < mid.x + tmpH ; ++x){
                int pixel = reference.getPixel(x,y);
                sumR += Color.red(pixel);
                sumG += Color.green(pixel);
                sumB += Color.blue(pixel);
                ++cnt;
            }
        }
        sumR = sumR/cnt + 30;
        sumG = sumG/cnt + 30;
        sumB = sumB/cnt + 30;
        if (sumR > 255)
            sumR = 255;
        if (sumG > 255)
            sumG = 255;
        if (sumB > 255)
            sumB = 255;

        Paint lowerlipPaint = newPaintLine(sumR,sumG,sumB,1, Paint.Style.FILL);

        sumR = 0;
        sumG = 0;
        sumB = 0;
        cnt = 0;

        tmpH = (allPoint[106].y - allPoint[95].y)/4;
        mid = new Point((allPoint[95].x + allPoint[106].x)/2,(allPoint[95].y + allPoint[106].y)/2);
        for(int y = (int)(mid.y - tmpH) ; y < mid.y + tmpH ; ++y){
            for(int x = (int)(mid.x - tmpH) ; x < mid.x + tmpH ; ++x){
                int pixel = reference.getPixel(x,y);
                sumR += Color.red(pixel);
                sumG += Color.green(pixel);
                sumB += Color.blue(pixel);
                ++cnt;
            }
        }
        sumR = sumR/cnt + 30;
        sumG = sumG/cnt + 30;
        sumB = sumB/cnt + 30;
        if (sumR > 255)
            sumR = 255;
        if (sumG > 255)
            sumG = 255;
        if (sumB > 255)
            sumB = 255;
        Paint upperlipPaint = newPaintLine(sumR,sumG,sumB,1, Paint.Style.FILL);

        points.add(allPoint[92]);points.add(allPoint[94]);points.add(allPoint[93]);points.add(allPoint[95]);
        points.add(allPoint[96]);points.add(allPoint[97]);points.add(allPoint[98]);points.add(allPoint[99]);
        points.add(allPoint[100]);points.add(allPoint[102]);points.add(allPoint[103]);points.add(allPoint[104]);
        points.add(allPoint[92]);
        //points.add(allPoint[80]);points.add(allPoint[82]);
        /*
        mouthPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 2 ; ++i){
            Point p2 = points.get(i+1);
            Point p3 = points.get(i+2);
            mouthPath.quadTo(p2.x,p2.y,p3.x,p3.y);
            mouthPath.lineTo(p2.x,p2.y);
        }*/
        /*
        //only upper
        points.add(allPoint[80]); points.add(allPoint[92]); points.add(allPoint[91]); points.add(allPoint[90]);
        points.add(allPoint[88]); points.add(allPoint[87]); points.add(allPoint[86]); points.add(allPoint[96]);
        points.add(allPoint[97]);points.add(allPoint[98]);points.add(allPoint[80]);


        points.add(allPoint[85]);
        points.add(allPoint[84]); points.add(allPoint[83]); points.add(allPoint[81]); points.add(allPoint[82]);
        points.add(allPoint[80]);
        */

        mouthPath.moveTo(points.get(0).x,points.get(0).y);
        for(int i = 0 ; i < points.size() - 1 ; ++i){
            if (i == 0 || i == 5 || i == 6 || i == 7 || i == 11 || i == 12){
                Point p1 = points.get(i);
                Point p2 = points.get(i + 1);
                int w = Math.abs(p2.x - p1.x);
                int h = Math.abs(p2.y - p1.y);
                mid = new Point((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);

                if (p2.x >= p1.x)
                    mouthPath.quadTo(mid.x, mid.y + h / 4, p2.x, p2.y);
                else
                    mouthPath.quadTo(mid.x, mid.y - h / 4, p2.x, p2.y);
            }
            else {
                Point p1 = points.get(i);
                Point p2 = points.get(i+1);
                Point p3 = points.get(i+2);
                mouthPath.cubicTo(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
            }
        }

        mouthRegion.setPath(mouthPath,new Region(MouthLeftPoint.x,MouthPeak.y,MouthRightPoint.x,allPoint[102].y));
        //drawCurve(canvas,points,lowerlipPaint,false);
        points.clear();

        points.add(allPoint[92]);points.add(allPoint[105]);points.add(allPoint[106]);points.add(allPoint[107]);
        points.add(allPoint[98]);points.add(allPoint[97]);points.add(allPoint[96]);points.add(allPoint[95]);
        points.add(allPoint[93]);points.add(allPoint[94]);points.add(allPoint[92]);
        //drawCurve(canvas,points,upperlipPaint,false);
        points.clear();




        float lipHeight = (float)(allPoint[102].y - allPoint[95].y);
        if( (allPoint[109].y - allPoint[106].y) > 0.15 * lipHeight) {  // 如果嘴巴打開程度 > 5%嘴唇高度 就畫出來
            // 嘴唇(內)
            // 處理牙齒部分 // 80 86分五等分
            Bitmap lip = Bitmap.createBitmap(src.getWidth(),src.getHeight(), Bitmap.Config.ARGB_8888);
            tmpCanvas = new Canvas(lip);
            // 畫出牙齒(白色)
            points.add(allPoint[92]); points.add(allPoint[105]); points.add(allPoint[106]); points.add(allPoint[107]);
            points.add(allPoint[98]); points.add(allPoint[108]); points.add(allPoint[109]); points.add(allPoint[110]);
            drawCurve(tmpCanvas, points, teethPaint, true);
            // 畫出牙齒間隔(黑色)
            float space = ((float)allPoint[98].x - (float)allPoint[92].x)/6;
            for(int i=1 ; i <= 5 ; ++i)
                tmpCanvas.drawLine(allPoint[92].x + i*space,allPoint[95].y,allPoint[92].x + i*space,allPoint[102].y,eyePaint);
            canvas.drawBitmap(lip,0,0,p);

            points.clear();
        }
//        else {
//            // 嘴唇線
//            points.add(allPoint[80]); points.add(allPoint[97]); points.add(allPoint[86]);
//            drawCurve(canvas, points, lipLinePaint, false);
//            points.clear();
//        }

        // 臉 排除 雙眼、鼻子、嘴唇剩下的地方
        Region finalRegion = new Region(faceRegion);  // copy faceRegion
        finalRegion.op(leftEyeRegion, Region.Op.XOR);
        finalRegion.op(rightEyeRegion, Region.Op.XOR);
//        finalRegion.op(noseRegion, Region.Op.XOR);
        finalRegion.op(mouthRegion, Region.Op.XOR);



//        drawRegion(canvas,finalRegion,whitePaint);

        int gray_temp, red_temp, green_temp, blue_temp;
        int new_color;
        float[] hsv = new float[3];
        for(int i=0 ; i<gray.getWidth() ; i++) {
            for (int j = 0; j < gray.getHeight(); j++) {
                if(finalRegion.contains(i,j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));
                    red_temp = Color.red(src.getPixel(i, j));
                    green_temp = Color.green(src.getPixel(i, j));
                    blue_temp = Color.blue(src.getPixel(i, j));
                    Color.RGBToHSV(red_temp, green_temp, blue_temp, hsv);

                    if(gray_temp < 75)
                        hsv[2] *= (float)gray_temp/255 + (float)0.285;
                    else if (gray_temp >= 75 && gray_temp < 125)
                        hsv[2] *= (float)gray_temp/255 + (float)0.325;
                    else if (gray_temp >= 125 && gray_temp < 150)
                        hsv[2] *= (float)gray_temp/255 + (float)0.35;
                    else if (gray_temp >= 150)
                        hsv[2] *= (float)gray_temp/255 + (float)0.375;

                    if(hsv[2] > 1)
                        hsv[2] = 1;


                    new_color = Color.HSVToColor(hsv);
                    src.setPixel(i,j,new_color);
                }

                if(mouthRegion.contains(i,j) || rightEyeRegion.contains(i,j) || leftEyeRegion.contains(i,j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));
                    red_temp = Color.red(reference.getPixel(i, j));
                    green_temp = Color.green(reference.getPixel(i, j));
                    blue_temp = Color.blue(reference.getPixel(i, j));
                    Color.RGBToHSV(red_temp, green_temp, blue_temp, hsv);
                    new_color = Color.HSVToColor(hsv);
                    src.setPixel(i,j,new_color);
                }
                hsv[2] = 0;

                if(leftEyebrowRegion.contains(i,j) || rightEyebrowRegion.contains(i,j)) {
                    gray_temp = Color.red(gray.getPixel(i, j));
                    red_temp = Color.red(src.getPixel(i, j));
                    green_temp = Color.green(src.getPixel(i, j));
                    blue_temp = Color.blue(src.getPixel(i, j));
                    Color.RGBToHSV(red_temp, green_temp, blue_temp, hsv);

                    //if(gray_temp > 50) {
                    hsv[2] *= (float) gray_temp / 255 + (float) 0.4;
                    if(hsv[2] > 1)
                        hsv[2] = 1;
                    new_color = Color.HSVToColor(hsv);
                    src.setPixel(i, j, new_color);
                    //}
                }
            }
        }

    }


    private Bitmap gray(Bitmap src,int alpha){
        Bitmap dst = Bitmap.createBitmap(src.getWidth(),src.getHeight(), Bitmap.Config.ARGB_8888);
        int width = src.getWidth();
        int height = src.getHeight();
        int[] srcPixels = new int[width * height];
        int[] dstPixels = new int[width * height];
        src.getPixels(srcPixels,0,width,0,0,width,height);  //取得 Pixels

        for(int i=0 ; i < width * height ; ++i) {
            int gray = (int) (0.299 * Color.red(srcPixels[i]) + 0.587 * Color.green(srcPixels[i]) + 0.114 * Color.blue(srcPixels[i]));
            dstPixels[i] = Color.argb(alpha,gray, gray, gray);
        }

        dst.setPixels(dstPixels,0,width,0,0,width,height);
        return dst;
    }
    private void drawRegion(Canvas canvas,Region rgn,Paint paint){
        RegionIterator iter = new RegionIterator(rgn);
        Rect r = new Rect();

        while (iter.next(r)) {
            canvas.drawRect(r, paint);
        }
    }

    private void drawTria(final Canvas canvas,
                          final float fromX,
                          final float fromY,
                          final float toX,
                          final float toY,
                          final int height,
                          final int bottom,
                          final Paint paintLine,
                          final Paint paintTri) {
        // height 三角形的高
        // bottom 三角形的底
        Canvas canvasTria = canvas;
        canvasTria.drawLine(fromX, fromY, toX, toY, paintLine);
        float juli = (float) Math.sqrt((toX - fromX) * (toX - fromX)
                + (toY - fromY) * (toY - fromY));// 取得線段距離
        float juliX = toX - fromX;// 有正負，不要取絕對值
        float juliY = toY - fromY;// 有正負，不要取絕對值
        float dianX = toX - (height / juli * juliX);
        float dianY = toY - (height / juli * juliY);
        float dian2X = fromX + (height / juli * juliX);
        float dian2Y = fromY + (height / juli * juliY);

        // 箭頭
        Path path = new Path();
        path.moveTo(toX, toY);    // 此點為三角形的起點(終點)
        path.lineTo(dianX + (bottom / juli * juliY),dianY - (bottom / juli * juliX));
        path.moveTo(toX, toY);    // 此點為三角形的起點(終點)
        path.lineTo(dianX - (bottom / juli * juliY),dianY + (bottom / juli * juliX));
//        path.close();            // 使這些點構成封閉的三角形
        canvas.drawPath(path, paintTri);

        path.moveTo(fromX,fromY); // 此點為三角形的起點(起點)
        path.lineTo(dian2X + (bottom / juli * juliY), dian2Y - (bottom / juli * juliX));
        path.moveTo(fromX, fromY);    // 此點為三角形的起點(終點)
        path.lineTo(dian2X - (bottom / juli * juliY), dian2Y + (bottom / juli * juliX));
//        path.close();            // 使這些點構成封閉的三角形
        canvas.drawPath(path, paintTri);
    }

    // from: https://blog.csdn.net/aotian16/article/details/21297097
    private Path curvePath = new Path();
    private final int STEPS = 12;
    private List<Integer> points_x = new ArrayList<>();
    private List<Integer> points_y = new ArrayList<>();
    private void drawCurve(Canvas canvas,ArrayList<Point> points,Paint paint,boolean closed){
        points_x.clear();
        points_y.clear();
        for (int i = 0; i < points.size(); i++) {
            points_x.add(points.get(i).x);
            points_y.add(points.get(i).y);
        }
        if(closed){
            points_x.add(points.get(0).x);
            points_y.add(points.get(0).y);
        }

        List<Cubic> calculate_x = calculate(points_x);
        List<Cubic> calculate_y = calculate(points_y);
        curvePath.moveTo(calculate_x.get(0).eval(0), calculate_y.get(0).eval(0));

        for (int i = 0; i < calculate_x.size(); ++i) {
            for (int j = 1; j <= STEPS ; ++j) {
                float u = j / (float) STEPS;
                curvePath.lineTo(calculate_x.get(i).eval(u), calculate_y.get(i).eval(u));
            }
        }
        canvas.drawPath(curvePath, paint);
        curvePath.reset();
    }




    private List<Cubic> calculate(List<Integer> x) {
        int n = x.size() - 1;
        float[] gamma = new float[n + 1];
        float[] delta = new float[n + 1];
        float[] D = new float[n + 1];
        int i;
        /*
         * We solve the equation [2 1 ] [D[0]] [3(x[1] - x[0]) ] |1 4 1 | |D[1]|
         * |3(x[2] - x[0]) | | 1 4 1 | | . | = | . | | ..... | | . | | . | | 1 4
         * 1| | . | |3(x[n] - x[n-2])| [ 1 2] [D[n]] [3(x[n] - x[n-1])]
         *
         * by using row operations to convert the matrix to upper triangular and
         * then back sustitution. The D[i] are the derivatives at the knots.
         */

        gamma[0] = 1.0f / 2.0f;
        for (i = 1; i < n; i++) {
            gamma[i] = 1 / (4 - gamma[i - 1]);
        }
        gamma[n] = 1 / (2 - gamma[n - 1]);

        delta[0] = 3 * (x.get(1) - x.get(0)) * gamma[0];
        for (i = 1; i < n; i++) {
            delta[i] = (3 * (x.get(i + 1) - x.get(i - 1)) - delta[i - 1])
                    * gamma[i];
        }
        delta[n] = (3 * (x.get(n) - x.get(n - 1)) - delta[n - 1]) * gamma[n];

        D[n] = delta[n];
        for (i = n - 1; i >= 0; i--) {
            D[i] = delta[i] - gamma[i] * D[i + 1];
        }

        /* now compute the coefficients of the cubics */
        List<Cubic> cubics = new LinkedList<Cubic>();
        for (i = 0; i < n; i++) {
            Cubic c = new Cubic(x.get(i), D[i], 3 * (x.get(i + 1) - x.get(i))
                    - 2 * D[i] - D[i + 1], 2 * (x.get(i) - x.get(i + 1)) + D[i]
                    + D[i + 1]);
            cubics.add(c);
        }
        return cubics;
    }

    private void polyBezier(Canvas canvas,ArrayList<Point> points, Paint mPaint,boolean closed){
        float startX, startY, conX, conY;
//        if(closed) points.add(points.get(0));

        Path tempPath = new Path();
//        tempPath.setFillType(Path.FillType.INVERSE_WINDING);
//        Paint tmpPaint = new Paint(mPaint);
//        tmpPaint.setStrokeWidth(1);

        float medX = points.get(0).x;
        float medY = points.get(0).y;


        float endX = points.get(1).x;
        float endY = points.get(1).y;
        int count = points.size();
        tempPath.moveTo(medX,medY);


        for(int i = 2; i < count ; i++){
            startX = medX;
            startY = medY;

            medX = endX;
            medY = endY;

            endX = points.get(i).x;
            endY = points.get(i).y;
            conX = (startX + 4 * medX - endX) / 4.0f;
            conY = (startY + 4 * medY - endY) / 4.0f;

//            tempPath.moveTo(startX, startY);
            tempPath.quadTo(conX, conY, medX, medY);
//            canvas.drawPath(tempPath, mPaint);

            if (i == count - 1){
                conX = (4 * medX + endX - startX) / 4.0f;
                conY = (4 * medY + endY - startY) / 4.0f;
//                tempPath.moveTo(medX, medY);
                tempPath.quadTo(conX, conY, endX, endY);
//                canvas.drawPath(tempPath, mPaint);

            }
        }
        tempPath.close();
//        tempPath.moveTo(points.get(0).x,points.get(0).y);
        canvas.drawPath(tempPath,mPaint);

    }
    private float cross(Point O,Point A,Point B){
        return (A.x - O.x) * (B.y - O.y) - (A.y - O.y) * (B.x - O.x);
    }
    private float cross(Point O,int x,int y,Point B) {
        return (x - O.x) * (B.y - O.y) - (y - O.y) * (B.x - O.x);
    }

    public static int getDominantColor(Bitmap bitmap) {
        if (bitmap == null) {
            return Color.TRANSPARENT;
        }
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        int size = width * height;
        int pixels[] = new int[size];
        //Bitmap bitmap2 = bitmap.copy(Bitmap.Config.ARGB_4444, false);
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height);
        int color;
        int r = 0;
        int g = 0;
        int b = 0;
        int a;
        int count = 0;
        for (int i = 0; i < pixels.length; i++) {
            color = pixels[i];
            a = Color.alpha(color);
            if (a > 0) {
                r += Color.red(color);
                g += Color.green(color);
                b += Color.blue(color);
                count++;
            }
        }
        r /= count;
        g /= count;
        b /= count;
        r = (r << 16) & 0x00FF0000;
        g = (g << 8) & 0x0000FF00;
        b = b & 0x000000FF;
        color = 0xFF000000 | r | g | b;
        return color;
    }
}
