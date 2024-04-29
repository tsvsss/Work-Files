package com.rmi.login.view.utils;


public class RmiUtils {
    public RmiUtils() {
        super();
    }

    public static boolean isNullOrEmptyString(String str) {
        return (str == null || "".equals(str));
    }

    public static boolean isNullOrEmptyObject(Object obj) {
        return (obj == null || "".equals(obj));
    }

    public static void main(String[] args) {
        String userName = "";
        String password ="pwd";
//        if (!RmiUtils.isNullOrEmptyString(password))
//            System.out.println("if");
//        else
//            System.out.println("else");
    }
}

