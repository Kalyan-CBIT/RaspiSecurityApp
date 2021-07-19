package com.example.security_cam;

import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.util.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.*;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter.native/helper";
    private final String UUID_STRING_WELL_KNOWN_SPP = "00001101-0000-1000-8000-00805F9B34FB";
    private BluetoothSocket bluetoothSocket = null;
    private boolean test = false;
    protected boolean isConnectedToSocket = false;

    private UUID myUUID;
    ArrayList<Map<String,String>> pairedDeviceArrayList;
    // BluetoothServiceRFCom objService = BluetoothServiceRFCom();
    BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
  super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            switch (call.method) {
              case "getBatteryLevel":
                    int batteryLevel = getBatteryLevel();
                    test = true;
                    if (batteryLevel != -1) {
                      result.success(batteryLevel);
                    } else {
                      result.error("UNAVAILABLE", "Battery level not available.", null);
                    }
              break;
              case "getBluetoothStatus":
                    System.out.println(test);
                    int res = isBluetoothEnabled();
                    result.success(res);
              break;
              case "getBondedDevices":
                    if(bluetoothAdapter.isEnabled())
                      result.success(getListofBonded());
                    else
                      result.success(pairedDeviceArrayList);
                    break;
                    
              default:
                    result.notImplemented();
                break;
            }
          }
        );
 }

  public int isBluetoothEnabled(){
    if (bluetoothAdapter.isEnabled()) {
        return 1;
    }
    return 0;
  }

  protected List<Map<String,String>> getListofBonded(){
    Set<BluetoothDevice> pairedDevices = bluetoothAdapter.getBondedDevices();
    if (pairedDevices.size() > 0) {
        pairedDeviceArrayList = new ArrayList<Map<String,String>>();
    for (BluetoothDevice device : pairedDevices) {
        Map<String,String> d = new HashMap<String, String>();
        d.put("name", device.getName());
        d.put("address",device.getAddress().toString());
        //  d.put("bondState", Integer(device.getBondState()).toString());
        //  d.put("class", Integer(device.getBluetoothClass()).toString());
        pairedDeviceArrayList.add(d);
    }
    }
    return pairedDeviceArrayList;
  }

  protected String sendData(byte[] buffer){
    if(!isConnectedToSocket) return "No Socket Connection";
    try{
        OutputStream ou = bluetoothSocket.getOutputStream();
        ou.write(buffer);
    }catch (IOException e){
        return e.toString();
    }
    return "sent";
}

 private List<String> getListOfString(Set<BluetoothDevice> bonded)
 {
  List<String> strings = new ArrayList<>(bonded.size());
  for (BluetoothDevice bluetoothDevice : bonded) {
      String name = bluetoothDevice.getName();
      // if(name.equals("raspberry"))
      // {
      //   try{
      //     System.out.println("Connecting");
      //     myUUID = UUID.fromString(UUID_STRING_WELL_KNOWN_SPP);
      //   BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
      //   bluetoothSocket =  bluetoothDevice.createInsecureRfcommSocketToServiceRecord(myUUID); 
      //   bluetoothSocket.connect();   }
      //   catch (IOException e) {
      //     System.out.println(e);
      //           try {
      //             System.out.println("Falling back");

      //               bluetoothSocket =(BluetoothSocket) bluetoothDevice.getClass().getMethod("createRfcommSocket", new Class[] {int.class}).invoke(bluetoothDevice,1);
      //               bluetoothSocket.connect();
      //               System.out.println("connected");
      //               OutputStream ou = bluetoothSocket.getOutputStream();
      //               byte[] buffer = "Succeded".getBytes();
      //               ou.write(buffer);
      //           }
      //           catch (Exception e2) {
      //             System.out.println("Couldn't establish Bluetooth connection!");
      //               try {
      //                 bluetoothSocket.close();
      //               } catch (IOException e1) {
      //                   // TODO Auto-generated catch block
      //                   System.out.println(e1);
      //               }
      //           }
      //   }
      // }
      // else{
      //   System.out.println(name);
      // }
      strings.add(Objects.toString(bluetoothDevice, null));
  }
  return strings;
 }
  

  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }

  

}
