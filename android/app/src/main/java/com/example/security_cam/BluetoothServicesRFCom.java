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
import android.content.pm.PackageManager;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;



public class BluetoothServicesRFCom{
    private static final int REQUEST_ENABLE_BT = 1;
    BluetoothAdapter bluetoothAdapter;
    static final int REQ_CODE_SPEECH_INPUT = 100;
    private BluetoothSocket bluetoothSocket = null;
    protected boolean isConnectedToSocket = false;

    ArrayList<Map<String,String>> pairedDeviceArrayList;
    private UUID myUUID;
    private final String UUID_STRING_WELL_KNOWN_SPP = "00001101-0000-1000-8000-00805F9B34FB";

    BluetoothServicesRFCom(){
        myUUID = UUID.fromString(UUID_STRING_WELL_KNOWN_SPP);

        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (bluetoothAdapter == null) {
            return;
        }
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

    protected boolean makeConnection(BluetoothDevice device){
        if(isConnectedToSocket) return isConnectedToSocket;
        try {
            // bluetoothSocket = device.createInsecureRfcommSocketToServiceRecord(myUUID);
            bluetoothSocket = device.createRfcommSocketToServiceRecord(myUUID);
        } catch (IOException e) {
            System.out.println(e);
        }
        if(bluetoothSocket!=null){
            try {
                bluetoothSocket.connect();
                System.out.println("connected");
                isConnectedToSocket = true;
            } catch (IOException e) {
                System.out.println(e);
                try {
                    System.out.println("Trying Fallback");
                    bluetoothSocket =(BluetoothSocket) device.getClass().getMethod("createRfcommSocket", new Class[] {int.class}).invoke(device,1);
                    bluetoothSocket.connect();
                    isConnectedToSocket = true;
                    System.out.println("connected");
                }
                catch (Exception e2) {
                    System.out.println("Couldn't establish Bluetooth connection!");
                    try {
                        bluetoothSocket.close();
                    } catch (IOException e1) {
                        System.out.println(e1);
                    }
                }
            }
        }
        return isConnectedToSocket;
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

    protected String receivedData(){
        String strReceived = "";
        if(!isConnectedToSocket) return "No Socket Connection";
        byte[] buffer = new byte[1024];
        int bytes;
        try{
            InputStream in = bluetoothSocket.getInputStream();
        bytes = in.read(buffer);
        strReceived = new String(buffer, 0, bytes);
        }catch (IOException e){
            System.out.println(e);
            return strReceived;
        }
        return strReceived;
    }

    protected void closeConnection(){
        if(!isConnectedToSocket) return;
        if(bluetoothSocket.isConnected()){
            try{
            bluetoothSocket.close();
            }catch (IOException e){
                System.out.println(e);
            }
            return;
        }
    }

}
